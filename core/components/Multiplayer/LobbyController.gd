extends Node

@export var play_offline_button: Button

@export var start_game_button: Button
@export var create_client_button: Button
@export var create_server_button: Button

@export var address_edit: LineEdit

#@export var offline_mode_selection_scene: PackedScene
#@export var main_scene: PackedScene

func _ready() -> void:
	MultiPlay.reset_peer()
	
	create_client_button.pressed.connect(MultiPlay.create_client)
	create_server_button.pressed.connect(MultiPlay.create_server)
	start_game_button.pressed.connect(start_game)
	play_offline_button.pressed.connect(start_game_offline)
	MultiPlay.created_peer.connect(_on_peer_created)
	address_edit.text_changed.connect(_on_edit_address)

func start_game():
	if multiplayer.is_server():
		_start_game.rpc()

@rpc("authority", "reliable", "call_local")
func _start_game():
	SceneManager.change_to_scene(SceneManager.SceneIndexes.GAME)

func start_game_offline():
	SceneManager.change_to_scene(SceneManager.SceneIndexes.OFFLINE_SELECTION)


func _on_peer_created():
	self.play_offline_button.disabled = true
	self.create_client_button.disabled = true
	self.create_server_button.disabled = true
	
	if multiplayer.is_server():
		self.start_game_button.disabled = false


func _on_edit_address(new_address: String):
	MultiPlay.IP_ADDRESS = new_address
