extends Node2D

@onready var music = $Music/Music

func _ready() -> void:
	TilemapManager.set_tilemap($Tilemap)
	music.play()
	
	var pet_scene = preload("res://entities/characters/nodes/pet/pet.tscn")
	for pet_name in SaveManager.save_data.pets:
		var pet_data = SaveManager.save_data.pets[pet_name]
		if World.Locations.MainSquare == pet_data.location:
			var pet = pet_scene.instantiate()
			pet.name = pet_name
			pet.pet_name = pet_name

			var coordinates = Vector2(pet_data.coordinates.x, pet_data.coordinates.y)
			pet.position = TilemapManager.get_global_position_from_coordinates(coordinates)
			add_child(pet)
