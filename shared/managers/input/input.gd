extends Node2D

## Game input control context
var context : Game.Context = Game.Context.Camera
var current_input : Controls.Type = Controls.Type.Touch

## Action signals
@warning_ignore("unused_signal") signal start_requested(data : InputData)
@warning_ignore('unused_signal') signal interaction_requested(data : InputData)
@warning_ignore('unused_signal') signal movement_requested(data : InputData)
@warning_ignore('unused_signal') signal prepare_zoom_requested(data : InputData)
@warning_ignore('unused_signal') signal zoom_requested(data : InputData)
@warning_ignore('unused_signal') signal find_requested(data : InputData)

## Input handle
func _input(event) -> void:
	
	var delta : float = get_process_delta_time()
	if not delta: 
		delta = 0.0

	if event is InputEventScreenTouch: 
		TouchInput.handle_touch(event, delta)
		return
		
	if event is InputEventScreenDrag:  
		TouchInput.handle_drag(event, delta)
		return
		
	if event is InputEventMouseMotion: 
		MouseInput.handle_mouse_motion(event, delta)
		return
	
	if event is InputEventMouseButton:
		MouseInput.handle_mouse_button(event, delta)

	if event is InputEventJoypadButton:
		GamepadInput.handle_joypad_button(event, delta)
		return
	
	if event is InputEventJoypadMotion:
		GamepadInput.handle_joypad_motion(event, delta)
		return
	
	if event is InputEventKey:
		KeyboardInput.handle_input_event_key(event, delta)
		return

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(Controls.CANCEL):
		get_tree().quit()
