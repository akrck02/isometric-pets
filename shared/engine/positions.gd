class_name Positions

## Convert relative to global positions
static func convert_to_scene_global_position(node_reference : Node2D, relative_position : Vector2) -> Vector2:
	return node_reference.get_viewport().get_canvas_transform().affine_inverse() * relative_position


## Convert canvas positions to global positions
static func convert_ui_position_to_scene_global_position(viewport : Viewport, canvas_position : Vector2) -> Vector2:
	return viewport.get_canvas_transform().affine_inverse() * canvas_position


## Get directions to face from coordinates
static func get_directions_from_coordinates(origin_coordinates : Vector2i, destiny_coordinates: Vector2i) -> Array[MoveEnums.Direction] :

	var delta_x = destiny_coordinates.x - origin_coordinates.x
	var delta_y = destiny_coordinates.y - origin_coordinates.y

	var directions : Array[MoveEnums.Direction] = [MoveEnums.Direction.None, MoveEnums.Direction.None]
	if origin_coordinates == destiny_coordinates:
		return directions

	if delta_x >= 1:		directions[0] = MoveEnums.Direction.Right
	elif delta_x <= -1:		directions[0] = MoveEnums.Direction.Left

	if delta_y >= 1:		directions[1] = MoveEnums.Direction.Down
	elif delta_y <= -1:		directions[1] = MoveEnums.Direction.Up

	return directions
