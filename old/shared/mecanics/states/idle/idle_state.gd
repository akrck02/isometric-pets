extends State
class_name IdleState

@export var pet_visuals: PetVisuals

## Logic for the entrance of the state
func enter(): 
	pet_visuals.animation_player.play("idle")
