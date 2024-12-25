extends Node

## Signals
signal new_game_created
signal save_game_requested
signal save_game_started
signal save_game_finished

@onready var timer : Timer = $Timer
const SAVE_TIME_INTERVAL = 5
const SAVE_FILE_PATH = "user://isopets.save"

var save_data : SaveData

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

	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.is_in_group("pets"): 
			save_data.set_pet(node.save())


	# Store the save dictionary as a new line in the save file.
	save_file.store_line(save_data.to_string())
	save_game_finished.emit()


## Save the pets
func save_pets():
	pass


## Save the quests
func save_quests():
	pass


## Save the inventory
func save_inventory():
	pass


## Load game
func load_game():

	if not FileAccess.file_exists(SAVE_FILE_PATH):
		FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE).store_string(SaveData.new().to_string())

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file_content = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ).get_as_text()
	save_data = SaveData.from_json(save_file_content)
