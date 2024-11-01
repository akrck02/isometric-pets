extends State
class_name FollowState

@export var animation : AnimationPlayer
@export var navigation : NavigationNode
@export var visual_area : Area2D;

var target : Node2D
var latest_target_coordinates : Vector2i


## Logic to be executed when node is ready
func _ready() -> void:
	visual_area.body_entered.connect(request_enter)
	visual_area.body_exited.connect(request_exit)

## Logic to be executed before the state enters
func enter() -> void:
	navigation.clear()
	animation.play("walk")
	navigation.requested.connect(move)
	navigation.finished.connect(handle_navigation_finish)

## Logic to be executed before the state exits
func exit() -> void:
	navigation.clear()
	navigation.requested.disconnect(move)
	navigation.finished.disconnect(handle_navigation_finish)

## handle_navigation_finish
func handle_navigation_finish() -> void:
	latest_target_coordinates = Vector2.ZERO
	navigation.clear()


## Logic for the tick update of the state
func tick() -> void:
	
	if not target or not navigation or not navigation.tilemap:
		return

	calculate_path()
	navigation.step()
	await navigation.requested


## Calculate path if needed
func calculate_path() -> void: 
	var target_coordinates = navigation.tilemap.get_coordinates_from_global_position(target.global_position)
	if latest_target_coordinates == target_coordinates:
		return
		
	navigation.calculate_path_to(target_coordinates)
	navigation.navigation_path.pop_back()
	latest_target_coordinates = target_coordinates


## Move to the requested position
func move(new_coordinates) -> void:
	navigation.step_node_to(actor, new_coordinates)


## Request to enter the state
func request_enter(body : Node2D) -> void:
	
	if not body.is_in_group("followable"):
		return
	
	target = body
	enter_requested.emit(self)


## Request to exit the state
func request_exit(body : Node2D) -> void:
	
	if body != target:
		return
	
	navigation.clear()
	exit_requested.emit(self)
	
