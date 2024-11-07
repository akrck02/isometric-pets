extends CharacterBody2D

# State management
@onready var states : StateMachine = $States

# Navigation
@onready var navigation : NavigationNode = $Navigation
@onready var follow_area : Area2D = $FollowArea

## Dependency injection
var dependencies : DependencyDatabase = DependencyDatabase.for_node("WanderingAnimal")


## Initial logic of the node
func _ready():
	
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return
