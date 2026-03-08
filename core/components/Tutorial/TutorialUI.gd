extends Control

@export var show_close_button: bool
@export var tutorial_images: Array[CompressedTexture2D] = []
@export var mobile_tutorial_images: Array[CompressedTexture2D] = []
var selected_tutorial_images: Array[CompressedTexture2D] = []

@export_category("UI Elements")
@export var close_button: Button
@export var tutorial_image_rect: TextureRect
@export var current_image_label: Label
@export var previous_image_button: Button
@export var next_image_button: Button

var current_image: int = 0

func _ready() -> void:
	selected_tutorial_images = tutorial_images
	if OS.has_feature("mobile"):
		selected_tutorial_images = mobile_tutorial_images
	
	self.close_button.visible = self.show_close_button
	
	self.close_button.pressed.connect(_on_close_button_pressed)
	self.previous_image_button.pressed.connect(previous_image)
	self.next_image_button.pressed.connect(next_image)
	update_ui_states()


func previous_image():
	self.change_image(self.current_image - 1)

func next_image():
	self.change_image(self.current_image + 1)


func change_image(image_idx: int):
	if image_idx >= len(selected_tutorial_images):
		return
	
	if image_idx < 0:
		return
	
	self.current_image = image_idx
	self.tutorial_image_rect.texture = self.selected_tutorial_images[self.current_image]
	update_ui_states()

func update_ui_states():
	self.current_image_label.text = str(self.current_image + 1) + "/" + str(len(selected_tutorial_images))
	self.previous_image_button.disabled = self.current_image - 1 < 0
	self.next_image_button.disabled = self.current_image + 1 >= len(selected_tutorial_images)


func _on_close_button_pressed():
	self.visible = false
