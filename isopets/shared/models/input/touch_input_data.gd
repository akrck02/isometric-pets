class_name TouchInputData

var type : Inputs.Type = Inputs.Type.Tap
var touch_points : Dictionary = {}
var relative : Vector2 = Vector2.ZERO # This is only filled on drag move type
var index : int = -1;

var drag_start_distance : float = 0 # Start distance of the drag


## Create an InputData from the given parameters
static func from(new_index : int, new_type : Inputs.Type, new_touch_points : Dictionary) -> TouchInputData:
	var data = new()
	data.index = new_index
	data.type = new_type
	data.touch_points = new_touch_points
	return data


## Get the relative position of the current event
func get_current_position() -> Vector2:
	return get_position(self.index)


## Get the relative position of any other event occurred at the same time
func get_position(id : int) -> Vector2:
	return touch_points[id]


## Get the global position of the current event
func get_current_global_position(viewport : Viewport) -> Vector2:
	return get_global_position(viewport, self.index)


## Get the global position of any other event occurred at the same time
func get_global_position(viewport : Viewport, id : int) -> Vector2:
	return Positions.convert_ui_position_to_scene_global_position(viewport, touch_points[id])


## Calculate distance between the given events
func calculate_distance_between(origin_id : int, final_id : int) -> float:
	var touch_point_positions = touch_points.values()
	return touch_point_positions[origin_id].distance_to(touch_point_positions[final_id])


## Get the drag distance factor
func get_drag_distance_factor() -> float:
	var current_distance = calculate_distance_between(0,1)
	var factor = drag_start_distance / current_distance
	return factor 
