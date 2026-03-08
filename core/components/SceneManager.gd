extends Node
class_name ScenesManager

const SCENES: Array[PackedScene] = [
	preload("res://core/scene/Lobby.tscn"),
	preload("res://core/test/Game.tscn"),
	preload("res://core/scene/OfflineSelection.tscn")
]

enum SceneIndexes {
	LOBBY,
	GAME,
	OFFLINE_SELECTION
}

static func packed_scene(index: SceneIndexes):
	return SCENES[index]

func change_to_scene(index: SceneIndexes):
	get_tree().change_scene_to_packed(
		packed_scene(index)
	)
