extends Control

@onready var container : MarginContainer = $MarginContainer
@onready var character_name_label : Label = $MarginContainer/DialogueContainer/MarginContainer/VBoxContainer/CharacterName
@onready var character_sprite : Sprite2D = $MarginContainer/Control/CharacterSprite
@onready var text_label : Label = $MarginContainer/DialogueContainer/MarginContainer/VBoxContainer/Text
@onready var timer : Timer = $Timer

var on_track : bool = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UIManager.dialogue_started.connect(_show_dialogue)

## Show the dialogue
func _show_dialogue():
	show()
	
	if on_track: return

	on_track = true	
	character_name_label.text = InteractionManager.current_npc.character_name.to_pascal_case()
	character_sprite.texture = InteractionManager.current_npc.sprite.texture
	
	var text =  InteractionManager.current_npc.dialogue.current()
	text_label.text = ""

	for character in text:
		text_label.text += character
		
		match character:
			" " :  timer.wait_time = randf_range(.06,.07)
			",", ".": timer.wait_time = randf_range(.15,.25)
			_: timer.wait_time = randf_range(.02,.05)

		timer.start()
		await timer.timeout
		
	on_track = false
