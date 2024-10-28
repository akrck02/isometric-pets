extends Control

var started : bool = false
var next_scene : String = Paths.get_world().get_scene() # Paths.get_debug_scene("test").get_scene() 


## Ready function
func _ready() -> void:
	InputManager.interaction_requested.connect(_start_game)
	InputManager.start_requested.connect(_start_game)

func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed(Controls.INTERACT):
		_start_game(null)

## Start the game
func _start_game(_data : InputData) -> void:
	started = true
	SignalDatabase.scene_change_requested.emit(next_scene)
	queue_free()
