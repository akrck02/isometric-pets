extends Node

const DIALOGUE_FILE_PATH : String = "res://dialogues/en/isopets.dialogues.json"
var data : Dictionary = {}

func _ready() -> void:
	
	# If the file does not exists, create it with default values 
	if not FileAccess.file_exists(DIALOGUE_FILE_PATH):
		printerr("INSTALATION IS CORRUPTED: Dialogue file does not exists!")
		get_tree().quit(1)

	# Load the file and process that text to restore the save data.
	var text = FileAccess.open(DIALOGUE_FILE_PATH, FileAccess.READ).get_as_text()
	data = JSON.parse_string(text)


## Get a given dialogue for a character
func get_dialogue(character: String, key : String) -> Array[String]:
	
	if not data.has(character): 
		return []
		
	var character_dialogues : Dictionary = data[character]
	if not character_dialogues.has(key):
		return []
	
	var result : Array[String] = []
	result.assign(character_dialogues[key])
	return result


## Get the dialogue keys for a character
func get_dialogue_keys(character: String) -> Array[String]:
	
	var keys : Array[String] = []
	
	if not data.has(character): 
		return keys
	
	var character_dialogues : Dictionary = data[character]
	for key in character_dialogues: 
		keys.append(key)
	
	return keys
