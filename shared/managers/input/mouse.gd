extends Node
class_name MouseInput

## Mouse motion handle
static func handle_mouse_motion(event : InputEventMouseMotion):
	InputManager.current_input = Controls.Type.KeyboardAndMouse


## Mouse mouse button
static func handle_mouse_button(event : InputEventMouseButton):
	InputManager.current_input = Controls.Type.KeyboardAndMouse
	
	var data = InputData.new();
	data.origin = Controls.Type.KeyboardAndMouse
	data.keyboard_and_mouse_data = KeyboardAndMouseInputData.new()
	
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		data.keyboard_and_mouse_data.zoom_percentage = 1.05
		InputManager.zoom_requested.emit(data)
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		data.keyboard_and_mouse_data.zoom_percentage = 0.95
		InputManager.zoom_requested.emit(data)
		return
