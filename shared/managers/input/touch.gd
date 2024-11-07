extends Node
class_name TouchInput

static var touch_points : Dictionary = {}
static var start_distance : float = 0

## Touch events handle
static func handle_touch(event : InputEventScreenTouch, delta : float):
	
	InputManager.current_input = Controls.Type.Touch
	
	# Unregister touch events on release
	if not event.pressed: 
		touch_points.erase(event.index)
		return;

	# Register touch events
	touch_points[event.index] =  event.position

	# Switch between the touch types
	var data = InputData.new()
	data.origin = Controls.Type.Touch
	data.delta = delta
	data.touch_data = TouchInputData.from(event.index, InputEnums.Type.Tap, touch_points)

	# Screen touch
	if touch_points.size() == 1 and not event.double_tap: 
		start_distance = 0
	
	# Screen pinch
	elif touch_points.size() == 2: 
		data.touch_data.type = InputEnums.Type.Pinch
		start_distance = data.touch_data.calculate_distance_between(0,1)
		InputManager.prepare_zoom_requested.emit(data)
	
	# Three finger touch
	elif touch_points.size() == 3: 
		data.touch_data.type = InputEnums.Type.ThreeFingerTap
		InputManager.find_requested.emit(data)


## Drag events handle 
static func handle_drag(event : InputEventScreenDrag, delta : float):
	
	InputManager.current_input = Controls.Type.Touch
	touch_points[event.index] = event.position
	
	var data = InputData.new();
	data.origin = Controls.Type.Touch
	data.delta = delta
	data.touch_data = TouchInputData.from(event.index, InputEnums.Type.Tap, touch_points)
	
	# Switch between drag types
	match touch_points.size():
		1:  
			data.touch_data.type = InputEnums.Type.DragMove
			data.touch_data.relative = event.relative
			InputManager.movement_requested.emit(data)
		2:  
			data.touch_data.type = InputEnums.Type.DragPinch
			data.touch_data.drag_start_distance = start_distance
			InputManager.zoom_requested.emit(data)
			
