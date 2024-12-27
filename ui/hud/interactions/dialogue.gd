extends Control

@onready var container : MarginContainer = $MarginContainer
@onready var character_name_label : Label = $MarginContainer/DialogueContainer/MarginContainer/VBoxContainer/CharacterName
@onready var character_sprite : Sprite2D = $MarginContainer/Control/CharacterSprite
@onready var text_label : Label = $MarginContainer/DialogueContainer/MarginContainer/VBoxContainer/Text
@onready var next_dialogue_button = $NextMarginContainer/NextButton
@onready var timer : Timer = $Timer

@export var speed : int = 50 

var on_track : bool = false
var current_dialogue : Array[String] = []
var current_dialogue_index : int = 0

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UIManager.dialogue_started.connect(_show_dialogue)
	next_dialogue_button.pressed.connect(_next_dialogue)
	speed = SettingsManager.get_text_speed()


## Show the dialogue
func _show_dialogue():
	
	if on_track: return

	show()
	character_name_label.text = InteractionManager.current_npc.character_name.to_pascal_case()
	character_sprite.texture = InteractionManager.current_npc.sprite.texture
	
	_load_current_dialogue()
	_show_line()


func _show_line() -> void:
	
	on_track = true
	var text = ["..."]
	
	if current_dialogue.size() > current_dialogue_index:
		text = current_dialogue[current_dialogue_index]
	
	text_label.text = ""

	for character in text:
		text_label.text += character
		
		match character:
			" " :  timer.wait_time = randf_range(.06,.07) / speed
			",", ".": timer.wait_time = randf_range(.15,.25) / speed
			_: timer.wait_time = randf_range(.02,.05) / speed

		timer.start()
		await timer.timeout
	
	on_track = false


## Load current dialogue
func _load_current_dialogue() -> void:
	
	current_dialogue =  InteractionManager.current_npc.dialogue.current()
	current_dialogue_index = 0

## Show next dialogue
func _next_dialogue():

	if on_track: return

	if current_dialogue_index >= current_dialogue.size() - 1: 
		on_track = false
		InteractionManager.stop_interactions()
		InputManager.context = Game.Context.Camera
		hide()
		return

	current_dialogue_index += 1
	_show_line()
