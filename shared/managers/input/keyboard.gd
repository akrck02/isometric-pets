extends Node
class_name KeyboardInput

## Keyboard events handle
static func handle_input_event_key(_event : InputEventKey, delta : float):
	
	var data : InputData = InputData.new()
	data.origin = Controls.Type.KeyboardAndMouse
	data.delta = delta
	data.keyboard_and_mouse_data = KeyboardAndMouseInputData.new()
	
	if Input.is_action_just_pressed(Controls.FULLSCREEN):
		SettingsManager.toggle_fullscreen.emit()
		return
	
	if Input.is_action_just_pressed(Controls.START):
		InputManager.start_requested.emit(data)
		return
	
	if Input.is_action_just_pressed(Controls.FIND):
		InputManager.find_requested.emit(data)
		return
	
	var direction : Vector2 = Vector2.ZERO 

	if Input.is_action_pressed(Controls.UP):
		direction += Vector2.UP
		
	if Input.is_action_pressed(Controls.DOWN):
		direction += Vector2.DOWN
	
	if Input.is_action_pressed(Controls.LEFT):
		direction += Vector2.LEFT
		
	if Input.is_action_pressed(Controls.RIGHT):
		direction += Vector2.RIGHT
	
	if direction != Vector2.ZERO:
		data.keyboard_and_mouse_data.direction = direction
		InputManager.movement_requested.emit(data)
		
