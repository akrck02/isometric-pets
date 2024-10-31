class_name NavigationNode
extends Node2D


## Standard grid navigation agent
@onready var navigation_agent : GridNavigationAgent2D = $GridNavigationAgent2D

## Calculate current coordinates
func calculate_current_coordinates() -> GridNavigationData:
		
	var data = GridNavigationData.new()
	data.current_coordinates = TilemapManager.get_coordinates_from_global_position(global_position)
	return data


## Calculate the navigation path 
func calculate_path_to(destiny_coordinates : Vector2i) -> GridNavigationData:

	var data = calculate_current_coordinates()
	data.path = navigation_agent.get_grid_navigation_path(destiny_coordinates) 
	return data


## Request step to the next path coordinates
func next(data : GridNavigationData) -> GridNavigationData:

	if not data or data.path.is_empty() or navigation_agent.is_navigation_finished():
		return data
	
	var next_coordinates = data.path.front()
	data.next_coordinates = next_coordinates
	data.path.pop_front()
	return data

## Create a line woth the path
func get_debug_path_line(data : GridNavigationData, color : Color) -> Line2D:
	
	if not data or not color:
		return null
		
	var path_line = Line2D.new()
	path_line.default_color = color
	path_line.width = 1
	path_line.z_index = 2
	path_line.antialiased = true
	path_line.joint_mode = Line2D.LINE_JOINT_BEVEL
	
	for point in data.path:  
		path_line.add_point(TilemapManager.get_global_position_from_coordinates(point)) 

	return path_line
