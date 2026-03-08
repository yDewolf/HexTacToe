extends Node

@export var start_game_button: Button
@export var create_client_button: Button
@export var create_server_button: Button

@export var address_edit: LineEdit

@export var main_scene: PackedScene

func _ready() -> void:
	create_client_button.pressed.connect(Lobby.create_client)
	create_server_button.pressed.connect(Lobby.create_server)
	start_game_button.pressed.connect(start_game)
	Lobby.created_peer.connect(_on_peer_created)
	address_edit.text_changed.connect(_on_edit_address)

func start_game():
	if multiplayer.is_server():
		_start_game.rpc()

@rpc("authority", "reliable", "call_local")
func _start_game():
	get_tree().change_scene_to_packed(main_scene)

func _on_peer_created():
	self.create_client_button.disabled = true
	self.create_server_button.disabled = true
	
	if multiplayer.is_server():
		self.start_game_button.disabled = false


func _on_edit_address(new_address: String):
	Lobby.IP_ADDRESS = new_address
