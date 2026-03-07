extends Node

@export var start_game_button: Button
@export var create_client_button: Button
@export var create_server_button: Button

@export var main_scene: PackedScene

const PORT = 7777
const MAX_CLIENTS = 2
const IP_ADDRESS = "127.0.0.1"

func _ready() -> void:
	create_client_button.pressed.connect(Lobby.create_client)
	create_server_button.pressed.connect(Lobby.create_server)
	start_game_button.pressed.connect(start_game)
	Lobby.created_peer.connect(_on_peer_created)

func start_game():
	if multiplayer.is_server():
		_start_game.rpc()

@rpc("authority", "reliable", "call_local")
func _start_game():
	get_tree().change_scene_to_packed(main_scene)

func _on_peer_created():
	if multiplayer.is_server():
		self.start_game_button.disabled = false
