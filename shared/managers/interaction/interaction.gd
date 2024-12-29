extends Node

var current_pet : Pet
var current_npc : Npc


## Interact with a pet
func interact_with_pet(pet : Pet):
	
	stop_interactions()
	current_pet = pet
	current_pet.play_mood_animation()
	
	UIManager.interaction_started.emit()
	InputManager.context = Game.Context.PetInteraction
	pet.set_outline(true)


## Interact with an npc
func interact_with_npc(npc : Npc) -> void: 
	
	# If already in dialogue return
	if Game.Context.Dialogue == InputManager.context:
		return
	
	stop_interactions()
	current_npc = npc
	UIManager.dialogue_started.emit()
	InputManager.context = Game.Context.Dialogue
	
	npc.set_outline(true)


## Reset the outlines for the selected items 
func _reset_outlines() -> void:
	if null != current_npc:
		current_npc.set_outline(false)
	
	if null != current_pet:
		current_pet.set_outline(false)


## Stop the interactions
func stop_interactions() -> void:
	InputManager.context = Game.Context.Camera
	_reset_outlines()
	current_npc = null
	current_pet = null
	UIManager.interaction_ended.emit()
	
