extends Node
class_name KeyboardInput


## Keyboard events handle
static func handle(event : InputEventKey):
	
	if Input.is_action_just_pressed(Controls.FULLSCREEN):
		SettingsManager.toggle_fullscreen.emit()
	
	
