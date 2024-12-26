extends Node2D
class_name Dialogue

@export var character : String = ""
var dialogue_keys : Array[String] = []
var current_dialogue_id : int = 0


## Function to execute when node is ready
func _ready() -> void:
	load_for_character(character)


## Load dialogues for a given character
func load_for_character(character_name: String) -> void:
	character = character_name
	dialogue_keys = DialogueManager.get_dialogue_keys(character)
	current_dialogue_id = 0


## Get the current dialogue
func current() -> String:
	return DialogueManager.get_dialogue(character, dialogue_keys[current_dialogue_id])


## Skip to the next dialogue and return it
func next() -> String:
	
	if current_dialogue_id < dialogue_keys.size() - 1:
		current_dialogue_id += 1 
	
	return current()
	
	
