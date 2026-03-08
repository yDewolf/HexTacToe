extends Button

@export var ui_elements: Array[Control] = []
@export var default_visibility = false

func _ready() -> void:
	for ui_element in ui_elements:
		ui_element.visible = default_visibility
		ui_element.visibility_changed.connect(_on_ui_element_visible_changed)
	
	self.button_pressed = default_visibility
	self.pressed.connect(_on_pressed)

func _on_pressed():
	for ui_element in ui_elements:
		ui_element.visible = self.button_pressed

func _on_ui_element_visible_changed():
	self.button_pressed = ui_elements[0].visible
