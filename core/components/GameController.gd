extends Node
class_name GameController

@export var level_node: Node2D

@export var camera: Camera2D
@export var debug_layer: TileMapLayer
@export var debug_mode: bool = false

@export var background_layer: TileMapLayer
@export var red_layer: TileMapLayer
@export var blue_layer: TileMapLayer

@export var current_turn_label: RichTextLabel
@export var reset_button: Button
@export var moves_left_label: Label

@export var map_size: Vector2 = Vector2(100, 100)
var is_offline: bool = true

const TILESET_ID = 0
const WIN_CONDITION = 6
var placed_cells: Dictionary[Vector2i, HexCell] = {}
var running: bool = true
var finished_game: bool = false

var player_ids = [0, 1]
var player_id: int = 0

var steps: int = 0

const MOVES_PER_TURN: int = 2
var moves_left: int = 2

func _ready() -> void:
	_setup_background()
	reset_button.pressed.connect(request_reset)
	if multiplayer and not multiplayer.get_peers().is_empty():
		is_offline = false
		player_ids = [multiplayer.get_unique_id()]
		for id in multiplayer.get_peers():
			player_ids.append(id)
		
		if multiplayer.is_server():
			on_reset.rpc()
		
		return
	
	on_reset()

func _setup_background():
	for x in range(self.map_size.x):
		for y in range(self.map_size.y): 
			self.background_layer.set_cell(
				Vector2i(x - self.map_size.x / 2, y - self.map_size.y / 2),
				TILESET_ID,
				Vector2i.ZERO
			)

func _process(delta: float) -> void:
	if self.running:
		if not OS.has_feature("mobile"):
			if Input.is_action_just_pressed("Place"):
				var mouse_coords = background_layer.get_local_mouse_position()
				request_place_at.rpc(mouse_coords)
	
	if finished_game and multiplayer.is_server():
		on_finished.rpc()
		#on_reset.rpc()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.double_tap:
			request_place_at.rpc(background_layer.get_local_mouse_position())


func request_reset():
	# TODO: Add voting
	if multiplayer.is_server():
		on_reset.rpc()


@rpc("authority", "call_local", "reliable")
func on_finished():
	self.running = false

@rpc("authority", "call_local", "reliable")
func on_reset():
	self.running = true
	self.finished_game = false
	self.steps = 0
	self.placed_cells.clear()
	self.debug_layer.clear()
	self.red_layer.clear()
	self.blue_layer.clear()
	if multiplayer.is_server():
		update_turn.rpc(self.player_ids.pick_random())

@rpc("any_peer", "call_local", "reliable")
func request_place_at(coords: Vector2):
	if multiplayer.is_server():
		if not is_offline:
			if self.player_id != multiplayer.get_remote_sender_id():
				return
		
		var id = multiplayer.get_remote_sender_id() if not is_offline else self.player_id
		place_at.rpc(coords, id)


@rpc("authority", "call_local", "reliable")
func place_at(global_coords: Vector2, _player_id: int):
	var local_coords = background_layer.local_to_map(global_coords)
	var should_finish: bool = false
	if can_place_at(local_coords):
		var new_cell = _place_at(local_coords, _player_id)
		var cell_streak = new_cell.test_win_condition(self.placed_cells, WIN_CONDITION)
		
		if multiplayer.is_server():
			if cell_streak.is_empty():
				next_turn()
			
			if len(cell_streak) == WIN_CONDITION:
				should_finish = true
				var positions = [new_cell.position]
				for _cell in cell_streak:
					positions.append(_cell.position)
				
				paint_cell_streak.rpc(PackedVector2Array(positions))
	
	if multiplayer.is_server():
		self.finished_game = should_finish
		if self.finished_game: on_finished.rpc()

func _place_at(coords: Vector2, _player_id: int) -> HexCell:
	var new_cell = HexCell.new(coords, _player_id)
	if debug_mode:
		debug_layer.clear()
		for axis in new_cell.baked_axis_positions:
			for pos in axis:
				debug_layer.set_cell(pos, TILESET_ID, Vector2i(1, 0))
	
	self.placed_cells.set(coords, new_cell)
	if self.player_ids.find(self.player_id) == 1:
		self.red_layer.set_cell(coords, TILESET_ID, Vector2i(1, 1))
		return new_cell
	
	self.blue_layer.set_cell(coords, TILESET_ID, Vector2i(0, 1))
	return new_cell

func can_place_at(coords: Vector2i) -> bool:
	if self.background_layer.get_cell_atlas_coords(coords) == Vector2i(-1, -1):
		return false
	
	if self.blue_layer.get_cell_atlas_coords(coords) != Vector2i(-1, -1):
		return false
	
	if self.red_layer.get_cell_atlas_coords(coords) != Vector2i(-1, -1):
		return false
	
	return true

func next_turn():
	if not multiplayer.is_server():
		return
	
	self.moves_left -= 1
	if self.moves_left <= 0 or steps == 0:
		self.moves_left = MOVES_PER_TURN
		
		var next_idx = self.player_ids.find(self.player_id) + 1
		if next_idx >= player_ids.size():
			next_idx = 0
		
		self.player_id = self.player_ids[next_idx]
		if multiplayer:
			update_turn.rpc(self.player_id)
	
	if multiplayer:
		update_moves_left.rpc(self.moves_left)
	
	steps += 1

@rpc("authority", "call_local", "reliable")
func update_turn(_player_id: int):
	self.player_id = _player_id
	self.update_turn_label(_player_id)

func update_turn_label(_player_id: int):
	var bbcode = "[color=" + ("red" if self.player_ids.find(_player_id) == 1 else "blue") + "]"
	self.current_turn_label.set_text(
		bbcode + str(_player_id) + "'s turn"
	)

@rpc("authority", "call_local", "unreliable_ordered")
func update_moves_left(_moves_left: int):
	self.moves_left = _moves_left
	update_moves_left_label(_moves_left)

func update_moves_left_label(_moves_left: int):
	self.moves_left_label.text = "Moves left: " + str(_moves_left) + "/" + str(MOVES_PER_TURN)


@rpc("authority", "call_local", "reliable")
func paint_cell_streak(cells: PackedVector2Array):
	for pos in cells:
		self.debug_layer.set_cell(Vector2i(pos), TILESET_ID, Vector2i(1, 0))
