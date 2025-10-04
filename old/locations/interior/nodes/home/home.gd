extends Node2D

@onready var exit_area : Area2D = $ExitArea

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_area.input_event.connect(exit)

	var pet_scene = preload("res://entities/characters/nodes/pet/pet.tscn")
	for pet_name in SaveManager.save_data.pets:
		var pet_data = SaveManager.save_data.pets[pet_name]
		if World.Locations.Home == pet_data.location:
			var pet = pet_scene.instantiate()
			pet.name = pet_name
			pet.pet_name = pet_name

			var coordinates = Vector2(pet_data.coordinates.x, pet_data.coordinates.y)
			pet.position = TilemapManager.get_global_position_from_coordinates(coordinates)
			add_child(pet)


## Exit to map
func exit(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if event is not InputEventScreenTouch:
		return;
	
	if not event.double_tap:
		return 
	
	SceneManager.scene_change_requested.emit(Paths.get_world().get_scene())
	queue_free()


	
