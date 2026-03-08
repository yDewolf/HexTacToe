extends Node

@export var ref_node: Node2D
@export var cursor_holder: Control
@export var cursor_scene: PackedScene

var cursors: Dictionary[int, PlayerCursor] = {}

func _ready() -> void:
	if Lobby != null:
		Lobby.created_peer.connect(_on_peer_created)
	
	for peer_id in multiplayer.get_peers():
		add_cursor(peer_id)

func _on_peer_created():
	Lobby.peer.peer_connected.connect(_on_peer_connected)
	Lobby.peer.peer_disconnected.connect(_on_peer_disconnected)


func _physics_process(delta: float) -> void:
	send_mouse_coords.rpc(self.ref_node.get_global_mouse_position())


@rpc("call_local", "any_peer", "unreliable_ordered")
func send_mouse_coords(mouse_coords: Vector2):
	if not multiplayer:
		return
	
	#print(multiplayer.get_remote_sender_id(), " sent ", mouse_coords)
	
	var cursor = self.cursors.get(multiplayer.get_remote_sender_id())
	if cursor != null:
		cursor.parse_mouse_coords(mouse_coords, multiplayer.get_remote_sender_id())

func add_cursor(id: int):
	var new_cursor: PlayerCursor = cursor_scene.instantiate()
	self.cursors[id] = new_cursor
	
	self.cursor_holder.add_child(new_cursor)
	new_cursor.set_peer_id(id)


func _on_peer_connected(id: int):
	add_cursor(id)

func _on_peer_disconnected(id: int):
	var cursor: PlayerCursor = self.cursors.get(id)
	if cursor != null:
		cursor.queue_free()
	
	self.cursors.erase(id)
