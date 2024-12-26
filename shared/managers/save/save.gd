extends Node

## Signals
signal new_game_created
signal save_game_requested
signal save_game_started
signal save_game_finished

## Constants
const SAVE_TIME_INTERVAL : int = 30
const SAVE_FILE_PATH : String = "user://isopets.save"
const PERSIST_GROUP : String = "persist"
const PETS_GROUP : String = "pets"

## Variables
@onready var timer : Timer = $Timer
var save_data : SaveData


## Function to execute when the manager loads
func _ready() -> void:
	load_game()
	save_game_requested.connect(save_game)

	timer.wait_time = SAVE_TIME_INTERVAL
	timer.one_shot = false
	timer.timeout.connect(save_game)
	timer.start()


## Save game
func save_game():
	save_game_started.emit()
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group(PERSIST_GROUP)
	for node in save_nodes:
		if node.is_in_group(PETS_GROUP): 
			save_data.set_pet(node.save())

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(save_data.to_string())
	save_game_finished.emit()


## Load game
func load_game():

	# If the file does not exists, create it with default values 
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE).store_string(SaveData.new().to_string())

	# Load the file and process that text to restore the save data.
	var save_file_content = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ).get_as_text()
	save_data = SaveData.from_json(save_file_content)
	
	## If no pet present
	if save_data.pets.is_empty():
		var pet_scene = preload("res://entities/characters/nodes/pet/pet.tscn")
		var pet_data = pet_scene.instantiate().save()
		pet_data.coordinates.x = 25
		pet_data.coordinates.y = -125
		
		save_data.set_pet(pet_data)
