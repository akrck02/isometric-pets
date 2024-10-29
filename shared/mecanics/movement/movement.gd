extends Node2D
class_name Movement

## Dependency injection
var dependencies : DependencyDatabase = DependencyDatabase.for_node("Movement")

# Standard procedural animation
@export var speed = 1.5
@onready var tween : Tween

## Tween node between coordinates
func step_node_to(node : Node2D, new_coordinates : Vector2i) -> void:
		
	tween = create_tween()
	var new_global_position : Vector2 = TilemapManager.get_global_position_from_coordinates(new_coordinates)
	tween.tween_property(node, NodeProperties.GlobalPosition, new_global_position, 1.00 / speed) #.set_trans(Tween.TRANS_SINE)
	await tween.finished
