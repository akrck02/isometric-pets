class_name MovementNode
extends Node2D

## Dependency injection
var dependencies : DependencyDatabase = DependencyDatabase.for_node("Movement")

@export var navigation : NavigationNode
@export var animation_player : AnimationPlayer
@export var visuals : Node2D

# Standard procedural animation
@export var speed = 1.5
@onready var tween : Tween
@onready var timer : Timer

func _ready() -> void:
	dependencies.add("navigation", navigation)
	dependencies.add("animation_player", animation_player)
	dependencies.add("visuals", visuals)
	dependencies.check()

## Tween node between coordinates
func step_node_to(node : Node2D, new_coordinates : Vector2i) -> void:
		
	tween = create_tween()
	var new_global_position : Vector2 = TilemapManager.get_global_position_from_coordinates(new_coordinates)
	tween.tween_property(node, NodeProperties.GlobalPosition, new_global_position, 1.00 / speed) #.set_trans(Tween.TRANS_SINE)
	await tween.finished

## Move towards coordinates in grid
func move_towards_in_grid(node : Node2D, new_coordinates : Vector2i) -> void:
	
	if new_coordinates == null:
		return;
		
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
	navigation.calculate_current_coordinates()
	var directions : Array[MoveEnums.Direction] = Positions.get_directions_from_coordinates(navigation.data.current_coordinates, new_coordinates)

	match  directions[0]:
		MoveEnums.Direction.Right:  
			visuals.scale.x = -1
		MoveEnums.Direction.Left:
			visuals.scale.x = 1

	match  directions[1]:
		MoveEnums.Direction.Up:  
			visuals.scale.x = -1
		MoveEnums.Direction.Down:
			visuals.scale.x = 1

	step_node_to(node,new_coordinates)
