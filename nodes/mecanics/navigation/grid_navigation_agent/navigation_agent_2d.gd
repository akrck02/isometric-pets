extends NavigationAgent2D
class_name  GridNavigationAgent2D

## Get the navigation path on grid
func get_grid_navigation_path(tilemap : TileMapExtended, destiny_coordinates : Vector2) -> Array[Vector2i]:
	
	if tilemap == null:
		push_warning("Tilemap is not set on navigation agent, so no navigation operations will be performed")
		return []
	
	self.target_position = tilemap.get_global_position_from_coordinates(destiny_coordinates)
	var _next = get_next_path_position()
	var current_path = get_current_navigation_path()
	
	var current_navigation_path : Array[Vector2i] = []
	for path_position in current_path:
		current_navigation_path.append(tilemap.get_coordinates_from_position(path_position))

	return remove_successive_steps_with_same_coordinates(current_navigation_path);

## Remove the steps with the same 
func remove_successive_steps_with_same_coordinates(current_navigation_path : Array[Vector2i]) -> Array[Vector2i]:
	
	if current_navigation_path.is_empty():
		return current_navigation_path
	
	var new_path : Array[Vector2i] = [current_navigation_path[0]]
	var last_coordinates : Vector2i = current_navigation_path[0]
	current_navigation_path.pop_front()
	
	for current_coordinates in current_navigation_path:

		if last_coordinates != current_coordinates:
			new_path.append(current_coordinates)
			last_coordinates = current_coordinates

	return new_path