extends Node

var current_pet : Pet

func set_interaction_target(pet : Pet):
	
	current_pet = pet
	current_pet.play_mood_animation()
	
	UIManager.notification_shown.emit("[center] {name} is {mood}".format({
		"name" : current_pet.pet_name,
		"mood" : CareEnums.mood_name_for(current_pet.stats.mood),
	}))
	
	UIManager.interaction_started.emit()
	InputManager.context = Game.Context.PetInteraction
