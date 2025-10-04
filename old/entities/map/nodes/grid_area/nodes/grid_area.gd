extends Area2D
class_name GridArea

var collisions : Dictionary

func _ready() -> void:
	collisions = {}
	body_entered.connect(register_collisions)
	body_exited.connect(unregister_collisions)

# Register bodies
func register_collisions(node : Node2D):
	collisions[node.get_index()] = node

# Unregister body
func unregister_collisions(node : Node2D):
	collisions.erase(node.get_index())
