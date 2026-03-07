extends Node

@export var level_node: Node2D

@export var background_layer: TileMapLayer
@export var red_layer: TileMapLayer
@export var blue_layer: TileMapLayer

@export var current_turn_label: Label
@export var reset_button: Button

@export var map_size: Vector2 = Vector2(100, 100)

const TILESET_ID = 0

enum Players {
	RED,
	BLUE
}

var turn: int = Players.RED:
	set(value):
		turn = value
		self.current_turn_label.text = str(Players.find_key(self.turn)) + "'s turn"

var steps: int = 0

const PLAYER_TURN_COUNT: int = 2
var player_turns: int = 2

func _ready() -> void:
	self.on_reset()
	for x in range(self.map_size.x):
		for y in range(self.map_size.y): 
			self.background_layer.set_cell(
				Vector2i(x - self.map_size.x / 2, y - self.map_size.y / 2),
				TILESET_ID,
				Vector2i.ZERO
			)
	
	reset_button.pressed.connect(on_reset)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Place"):
		var mouse_coords = background_layer.get_local_mouse_position()
		place_at(mouse_coords)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		place_at(event.position)


func on_reset():
	self.steps = 0
	self.red_layer.clear()
	self.blue_layer.clear()
	self.turn = Players.RED


func place_at(global_coords: Vector2):
	var local_coords = background_layer.local_to_map(global_coords)
	if can_place_at(local_coords):
		_place_at(local_coords)
		next_turn()

func _place_at(coords: Vector2):
	#if not can_place_at(coords):
		#return
	
	if self.turn == Players.RED:
		self.red_layer.set_cell(coords, TILESET_ID, Vector2i(1, 1))
		return
	
	self.blue_layer.set_cell(coords, TILESET_ID, Vector2i(0, 1))
	return

func can_place_at(coords: Vector2i) -> bool:
	if self.background_layer.get_cell_atlas_coords(coords) == Vector2i(-1, -1):
		return false
	
	if self.blue_layer.get_cell_atlas_coords(coords) != Vector2i(-1, -1):
		return false
	
	if self.red_layer.get_cell_atlas_coords(coords) != Vector2i(-1, -1):
		return false
	
	return true

func next_turn():
	self.player_turns -= 1
	if self.player_turns <= 0 or steps == 0:
		self.player_turns = PLAYER_TURN_COUNT
		self.turn = self.turn + 1
		if self.turn >= Players.size():
			self.turn = 0
	
	steps += 1
