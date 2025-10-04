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

var destiny_coordinates : Vector2i

## Logic for the entrance of the state
func enter(): 
	animation.play("RESET")
	update_route()
	navigation.navigation_agent.navigation_finished.connect(update_route)


## Move along the path
func tick():
	
	# If timer is active, no movement is allowed
	if not timer.is_stopped():
		return
	
	# Get next step data 
	var next_step_data : GridNavigationData = navigation.next(destiny_coordinates)
	if not next_step_data.enabled:
		return
	
	# Move in grid
	movement.move_towards_in_grid(actor, next_step_data.next_coordinates)
	
	# If the route is finished, calculate new one
	if navigation.data.finished:
		update_route()
	

## Update next
func update_route() -> void:
	
	# Set timer to wait 
	timer.one_shot = true
	timer.wait_time = randf_range(minimum_rest_time, maximum_rest_time)
	timer.start()
	await timer.timeout
	
	# Calculate next route
	await calculate_next_route()


## Calculate next route
func calculate_next_route() -> void:
	
	# Wait until the next physics frame to avoid early
	# non-loaded content to be updated
	await get_tree().physics_frame
	navigation.calculate_current_coordinates()
	
	destiny_coordinates = navigation.data.current_coordinates
	destiny_coordinates.x += randi_range(-5,5)
	destiny_coordinates.y += randi_range(-3,3)


## Check startup parameters
func _can_start() -> bool:
	dependencies.add("animation", animation)
	dependencies.add("navigation", navigation)
	dependencies.add("movement", movement)
	dependencies.add("timer", timer)
	return true
