extends State
class_name WanderState

@export_category("Dependencies")
@export var animation : AnimationPlayer
@export var navigation : NavigationNode
@export var movement : MovementNode

@export_category("Settings")
@export_range(0, 10, 0.25) var minimum_rest_time: float = 1
@export_range(0, 10, 0.25) var maximum_rest_time: float = 5

@onready var timer : Timer = $Timer


var navigation_data : GridNavigationData

## Logic for the entrance of the state
func enter(): 
	animation.play("RESET")
	update_route()
	navigation.navigation_agent.navigation_finished.connect(update_route)


## Move along the path
func tick():
	
	if not timer.is_stopped():
		return
	
	var new_data : GridNavigationData = navigation.next(navigation_data)
	if new_data == null:
		return
	
	navigation_data = new_data
	movement.move_towards_in_grid(actor, navigation_data.next_coordinates)
	
	if new_data.path.is_empty():
		# Leave state here
		timer.one_shot = true
		timer.wait_time = randf_range(minimum_rest_time,maximum_rest_time)
		timer.start()
		await timer.timeout
		update_route()


## Update next
func update_route() -> void:
	navigation_data = await calculate_next_route()


## Calculate next route
func calculate_next_route() -> GridNavigationData:
	
	await get_tree().physics_frame
	navigation_data = navigation.calculate_current_coordinates()
	if navigation_data == null:
		return
	
	var new_coordinates = navigation_data.current_coordinates
	new_coordinates.x += randi_range(-5,5)
	new_coordinates.y += randi_range(-3,3)
	return navigation.calculate_path_to(new_coordinates)


## Check startup parameters
func _can_start() -> bool:
	dependencies.add("animation", animation)
	dependencies.add("navigation", navigation)
	dependencies.add("movement", movement)
	dependencies.add("timer", timer)
	return true
