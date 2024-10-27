extends Node
class_name GamepadInput

static func handle():
	if Input.is_action_just_pressed(Controls.INTERACT):		
		InputManager.interaction_requested.emit()

	if Input.is_action_just_pressed(Controls.UP):
		InputManager.movement_requested.emit(Vector2.UP)
	
	if Input.is_action_just_pressed(Controls.DOWN):
		InputManager.movement_requested.emit(Vector2.DOWN * 50)
	
	if Input.is_action_just_pressed(Controls.LEFT):
		InputManager.movement_requested.emit(Vector2.LEFT)
	
	if Input.is_action_just_pressed(Controls.RIGHT):
		InputManager.movement_requested.emit(Vector2.RIGHT)
	
	if Input.is_action_just_pressed(Controls.FULLSCREEN):
		SettingsManager.toggle_fullscreen.emit()
	
	if Input.is_action_just_pressed(Controls.FIND):
		InputManager.find_requested.emit()
	
	if Input.is_action_pressed(Controls.ZOOM_IN):
		InputManager.zoom_requested.emit(Vector2(1.05,1.05))
	
	if Input.is_action_pressed(Controls.ZOOM_OUT):
		InputManager.zoom_requested.emit(Vector2(0.95,0.95))
