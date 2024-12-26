extends Node

var current_pet : Pet
var current_npc : Npc


## Interact with a pet
func interact_with_pet(pet : Pet):
	
	if null != current_npc:
		current_npc.set_outline(false)
	
	if null != current_pet:
		current_pet.set_outline(false)
	
	current_npc = null
	current_pet = pet
	current_pet.play_mood_animation()
	
	UIManager.notification_shown.emit("[center] {name} is {mood}".format({
		"name" : current_pet.pet_name,
		"mood" : CareEnums.mood_name_for(current_pet.stats.mood),
	}))
	
	UIManager.interaction_started.emit()
	InputManager.context = Game.Context.PetInteraction
	pet.set_outline(true)


## Interact with an npc
func interact_with_npc(npc : Npc) -> void: 
	
	# If already in dialogue return
	if Game.Context.Dialogue == InputManager.context:
		return
	
	if null != current_npc:
		current_npc.set_outline(false)
	
	if null != current_pet:
		current_pet.set_outline(false)
	
	current_npc = npc
	current_pet = null
	
	UIManager.dialogue_started.emit()
	InputManager.context = Game.Context.Dialogue
	npc.set_outline(true)
