extends Label


func _ready() -> void:
	self.text = "v" + ProjectSettings.get_setting("application/config/version")
