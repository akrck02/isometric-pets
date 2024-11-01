class_name  GridNavigationAgent2D
extends NavigationAgent2D

## Get next step towards the destiny
func get_next_step_towards(destiny_coordinates : Vector2) -> Vector2i:
	self.target_position = TilemapManager.get_global_position_from_coordinates(destiny_coordinates)
	var next = get_next_path_position()
	return TilemapManager.get_coordinates_from_global_position(next)
