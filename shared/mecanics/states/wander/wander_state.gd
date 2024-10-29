extends State
class_name WanderState

@export var animation : AnimationPlayer
@export var navigation : NavigationNode
@export var movement : Movement

var navigation_data : GridNavigationData

## Logic for the entrance of the state
func enter(): 
	animation.play("RESET")
	navigation_data = await calculate_next_route()


## Move along the path
func tick():
	var new_data : GridNavigationData = navigation.next(navigation_data)
	if new_data == null:
		return
	
	navigation_data = new_data
	movement.step_node_to(actor, navigation_data.next_coordinates)


## Calculate next route
func calculate_next_route() -> GridNavigationData:
	
	await get_tree().physics_frame
	navigation_data = navigation.calculate_current_coordinates()
	if navigation_data == null:
		return
	
	var new_coordinates = navigation_data.current_coordinates
	new_coordinates.x += randi_range(-5,5)
	new_coordinates.y += randi_range(-3,3)
	return await navigation.calculate_path_to(new_coordinates)


## Check startup parameters
func _can_start() -> bool:
	dependencies.add("animation", animation)
	dependencies.add("navigation", navigation)
	dependencies.add("movement", movement)
	return true
