class_name NavigationNode
extends Node2D

## Grid calcultaion algorithm
var astar_grid : AStarGrid2D = AStarGrid2D.new()

## Standard grid navigation agent
@onready var navigation_agent : GridNavigationAgent2D = $GridNavigationAgent2D
var data : GridNavigationData = GridNavigationData.new()

## Setup algorithm
func set_up_grid() -> void:
	astar_grid.region = Rect2i(1,1,1,1)
	pass


## Calculate current coordinates
func calculate_current_coordinates() -> void:
	data.current_coordinates = TilemapManager.get_coordinates_from_global_position(global_position)


## Request step to the next path coordinates
func next(destiny_coordinates : Vector2i) -> GridNavigationData:
	
	calculate_current_coordinates()
	if destiny_coordinates == data.current_coordinates:
		data.finished = true
		return data
	
	data.finished = false
	data.enabled = true
	data.next_coordinates = navigation_agent.get_next_step_towards(destiny_coordinates) 
	
	return data
