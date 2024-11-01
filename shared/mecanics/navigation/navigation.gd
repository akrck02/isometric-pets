class_name NavigationNode
extends Node2D

## Standard grid navigation agent
@onready var navigation_agent : GridNavigationAgent2D = $GridNavigationAgent2D
var data : GridNavigationData = GridNavigationData.new()


## Calculate current coordinates
func calculate_current_coordinates() -> void:
	data.current_coordinates = TilemapManager.get_coordinates_from_global_position(global_position)


## Request step to the next path coordinates
func next(destiny_coordinates : Vector2i) -> GridNavigationData:

	#if data.destiny_coordinates != 

#	if navigation_agent.is_navigation_finished():
#		data.finished = true
#		return data
	
	calculate_current_coordinates()
	data.enabled = true
	data.next_coordinates = navigation_agent.get_next_step_towards(destiny_coordinates) 
	return data
