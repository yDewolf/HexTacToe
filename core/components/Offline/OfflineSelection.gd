extends Control

#@export var main_scene: PackedScene
#@export var lobby_scene: PackedScene

@export_category("UI elements")
@export var against_player_button: Button
@export var against_bot_button: Button
@export var go_back_to_lobby: Button

func _ready() -> void:
	self.against_player_button.pressed.connect(_on_against_player)
	self.against_bot_button.pressed.connect(_on_against_bot)
	self.go_back_to_lobby.pressed.connect(_on_go_back_to_lobby)


func start_game():
	SceneManager.change_to_scene(SceneManager.SceneIndexes.GAME)


func _on_against_player():
	SoloPlay.ENABLE_BOT = false
	start_game()

func _on_against_bot():
	SoloPlay.ENABLE_BOT = true
	start_game()

func _on_go_back_to_lobby():
	SceneManager.change_to_scene(SceneManager.SceneIndexes.LOBBY)
