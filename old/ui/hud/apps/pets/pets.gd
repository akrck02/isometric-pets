extends App

## Signals
signal selected(pet_name : String)

## UI
@onready var rows : VBoxContainer = $VBoxContainer/Scroll/Rows 

## Constants
const PET_SELECTOR_BUTTON_SCENE = preload("res://ui/hud/selectors/pet/pet_selector_button.tscn")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for pet_name in SaveManager.save_data.pets:
		
		var button : PetSelectorButton = PET_SELECTOR_BUTTON_SCENE.instantiate()
		button.selected.connect(selected.emit)
		rows.add_child(button)
		
		var texture : Texture2D = load(Paths.get_pets().get_sprite("%s.png" % pet_name))
		button.set_pet("%s" % pet_name, texture)
