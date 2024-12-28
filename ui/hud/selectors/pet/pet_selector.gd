extends MarginContainer

@onready var rows : VBoxContainer = $Scroll/Rows 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var button_scene = preload("res://ui/hud/selectors/pet/pet_selector_button.tscn") 

	for pet in SaveManager.save_data.pets:
		var button = button_scene.instantiate()
		rows.add_child(button)
		
		var texture : AnimatedTexture = AnimatedTexture.new()
		texture.frames = 3
		button.set_pet("%s" % pet, texture)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
