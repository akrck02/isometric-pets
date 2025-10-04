extends Node
class_name GamepadInput


## Handle gamepad button related events
static func handle_joypad_button(_event : InputEventJoypadButton, delta : float):
	InputManager.current_input = Controls.Type.Gamepad
	
	var data : InputData = InputData.new();
	data.origin = Controls.Type.Gamepad
	data.delta = delta
	data.gamepad_data = GamepadInputData.new();
	
	if Input.is_action_just_pressed(Controls.INTERACT):
		InputManager.interaction_requested.emit()
		return
	
	if Input.is_action_just_pressed(Controls.FULLSCREEN):
		SettingsManager.toggle_fullscreen.emit()
		return
	
	if Input.is_action_just_pressed(Controls.FIND):
		InputManager.find_requested.emit(data)
		return
	
	if Input.is_action_just_pressed(Controls.START):
		InputManager.start_requested.emit(data)


## Handle gamepad motion related events
static func handle_joypad_motion(_event : InputEventJoypadMotion, delta : float):
	InputManager.current_input = Controls.Type.Gamepad
	
	var data : InputData = InputData.new();
	data.origin = Controls.Type.Gamepad
	data.delta = delta
	data.gamepad_data = GamepadInputData.new();
	
	if _joystick_moved():
		data.gamepad_data.direction = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
		InputManager.movement_requested.emit(data)
		return
	
	if Input.is_action_just_pressed(Controls.ZOOM_IN):
		data.gamepad_data.zoom_percentage = 1.25
		InputManager.zoom_requested.emit(data)
		return
	
	if Input.is_action_just_pressed(Controls.ZOOM_OUT):
		data.gamepad_data.zoom_percentage = 0.75
		InputManager.zoom_requested.emit(data)
		return
	


## Get if joystick moved
static func _joystick_moved():
	return Input.is_action_pressed(Controls.UP) or Input.is_action_pressed(Controls.DOWN) or Input.is_action_pressed(Controls.LEFT) or Input.is_action_pressed(Controls.RIGHT) 
