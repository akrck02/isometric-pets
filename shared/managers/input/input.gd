extends Node2D

## Game input control context
var context : Game.Context = Game.Context.Camera
var current_input : Controls.Type = Controls.Type.Touch

## Action signals
@warning_ignore('unused_signal') signal interaction_requested(data : InputData)
@warning_ignore('unused_signal') signal movement_requested(data : InputData)
@warning_ignore('unused_signal') signal prepare_zoom_requested(data : InputData)
@warning_ignore('unused_signal') signal zoom_requested(data : InputData)
@warning_ignore('unused_signal') signal find_requested(data : InputData)

## Input handle
func _input(event) -> void:

	if event is InputEventScreenTouch: 
		TouchInput.handle_touch(event)
		return
		
	if event is InputEventScreenDrag:  
		TouchInput.handle_drag(event)
		return
		
	if event is InputEventMouseMotion: 
		MouseInput.handle_mouse_motion(event)
		return
	
	if event is InputEventMouseButton:
		MouseInput.handle_mouse_button(event)

	if event is InputEventJoypadButton:
		GamepadInput.handle()
		return
	
	if event is InputEventJoypadMotion:
		GamepadInput.handle()
		return
	
	if event is InputEventKey:
		KeyboardInput.handle(event)
		return
	
