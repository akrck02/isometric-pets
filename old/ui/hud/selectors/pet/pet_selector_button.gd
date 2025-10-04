extends MarginContainer
class_name PetSelectorButton

signal selected(pet : String)

@onready var button : Button = $Button
@onready var pet_texture_rect : TextureRect = $Button/Columns/Container/PetTextureRect
@onready var eyes_texture_rect : TextureRect = $Button/Columns/Container/DecorationTextureRect
@onready var label : Label = $Button/Columns/LabelMargin/Label

var DEFAULT_SPRITE_SIZE = Vector2(80, 80)
var current_pet : String 


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_select)
	_trim()


## Set the pet
func set_pet(pet_name : String = "...", sprite: Texture = Texture2D.new()) -> void: 
	current_pet = pet_name
	label.text = pet_name
	pet_texture_rect.texture = sprite
	_trim()


## Trim the spritesheet
func _trim(trim_size : Vector2 = DEFAULT_SPRITE_SIZE) -> void: 
	var pet_atlas_texture := AtlasTexture.new()
	pet_atlas_texture.set_atlas(pet_texture_rect.texture)
	pet_atlas_texture.set_region(Rect2(Vector2.ZERO, trim_size))
	
	var eyes_atlas_texture := AtlasTexture.new()
	eyes_atlas_texture.set_atlas(eyes_texture_rect.texture)
	eyes_atlas_texture.set_region(Rect2(Vector2.ZERO, trim_size))
	
	pet_texture_rect.texture = pet_atlas_texture
	eyes_texture_rect.texture = eyes_atlas_texture


## Select event listener
func _on_select() -> void: 
	selected.emit(current_pet)
