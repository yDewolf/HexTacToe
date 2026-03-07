extends Camera2D

@export var level_node: Node2D

@export var zoom_factor: float = 0.5
@export var _zoom: float = 1.0:
	set(value):
		_zoom = max(value, zoom_factor)
		level_node.scale = Vector2(self._zoom, self._zoom)

@export var move_speed: float = 5.0

func _ready() -> void:
	self._zoom = level_node.scale.x

func _physics_process(delta: float) -> void:
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
