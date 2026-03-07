extends Control
class_name PlayerCursor

@export var cursor_label: Label
var peer_id: int

func set_peer_id(id: int):
	self.peer_id = id
	self.cursor_label.text = str(id)

func parse_mouse_coords(coords: Vector2, from_id: int):
	if self.peer_id != from_id:
		return
	
	self.global_position = coords
