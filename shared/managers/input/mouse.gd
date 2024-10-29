extends Node
class_name MouseInput

## Mouse motion handle
static func handle_mouse_motion(_event : InputEventMouseMotion, delta : float):
	InputManager.current_input = Controls.Type.KeyboardAndMouse
	
	var data = InputData.new();
	data.delta = delta
	data.origin = Controls.Type.KeyboardAndMouse
	data.keyboard_and_mouse_data = KeyboardAndMouseInputData.new()


## Mouse mouse button
static func handle_mouse_button(event : InputEventMouseButton, delta : float):
	InputManager.current_input = Controls.Type.KeyboardAndMouse
	
	var data = InputData.new();
	data.delta = delta
	data.origin = Controls.Type.KeyboardAndMouse
	data.keyboard_and_mouse_data = KeyboardAndMouseInputData.new()
	
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		data.keyboard_and_mouse_data.zoom_percentage = 1.08
		InputManager.zoom_requested.emit(data)
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		data.keyboard_and_mouse_data.zoom_percentage = 0.92
		InputManager.zoom_requested.emit(data)
		return
