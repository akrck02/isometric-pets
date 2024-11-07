extends State
class_name IdleState

@export var animation : AnimationPlayer

## Logic for the entrance of the state
func enter(): 
	animation.play("idle")
