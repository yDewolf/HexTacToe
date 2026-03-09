extends Camera2D

@export var zoom_in_button: Button
@export var zoom_out_button: Button

@export var ui: Control
var start_ui_size: Vector2
var start_ui_pos: Vector2
var ui_offset: Vector2

@export var zoom_factor: float = 0.5
@export var _zoom: float = 1:
	set(value):
		_zoom = max(value, zoom_factor)
		if ui:
			ui.scale = Vector2(1 / self._zoom, 1 / self._zoom)
		self.zoom = Vector2(_zoom, _zoom)

@export var move_speed: float = 5.0
var touch_points: Dictionary = {}

var start_distance: float = 0
var start_zoom: Vector2 = Vector2(_zoom, _zoom)

func _ready() -> void:
	_zoom = _zoom
	self.start_ui_pos = ui.position
	self.ui_offset = self.start_ui_pos
	
	self.start_ui_size = ui.size
	self.ui.resized.connect(_ui_resized)
	zoom_in_button.pressed.connect(zoom_in)
	zoom_out_button.pressed.connect(zoom_out)
	self._ui_resized()

func _ui_resized():
	self.ui_offset = -(self.ui.size) / 2


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		self._zoom += zoom_factor
	
	if Input.is_action_just_pressed("zoom_out"):
		self._zoom -= zoom_factor
	
	
	if Input.is_action_pressed("move_left"):
		self.position.x += -move_speed
	
	if Input.is_action_pressed("move_right"):
		self.position.x += move_speed
	
	if Input.is_action_pressed("move_up"):
		self.position.y += -move_speed
	
	if Input.is_action_pressed("move_down"):
		self.position.y += move_speed
	
	self.ui.set_position(self.position + self.ui_offset)
	self.ui.pivot_offset = -self.ui_offset


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		handle_touch(event)
	
	elif event is InputEventScreenDrag:
		handle_drag(event)


func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		
		start_zoom = zoom
	
	elif touch_points.size() < 2:
		start_distance = 0


func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		self.position -= event.relative * move_speed * 0.15 / _zoom
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_distance: float = touch_point_positions[0].distance_to(touch_point_positions[1])
		var _zoom_factor = start_distance / current_distance
		if _zoom_factor == 0:
			return
		
		_zoom = start_zoom.x / _zoom_factor

func zoom_in():
	self._zoom += self.zoom_factor

func zoom_out():
	self._zoom -= self.zoom_factor
