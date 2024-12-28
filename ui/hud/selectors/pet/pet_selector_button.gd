extends MarginContainer

signal pressed

@onready var button : Button = $Button
@onready var texture_rect : TextureRect = $Button/Columns/TextureRect
@onready var label : Label = $Button/Columns/Label


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(pressed.emit)


## Set the pet
func set_pet(name : String, sprite: AnimatedTexture) -> void: 
	label.text = name
	texture_rect.texture = sprite
