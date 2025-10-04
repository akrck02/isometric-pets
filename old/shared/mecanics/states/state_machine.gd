class_name StateMachine
extends Node2D

## Actor of the states
@export var actor : CharacterBody2D

## State management
signal state_change_requested(state : State)
@export var initial_state : State
var current_state : State
var states : Dictionary = {}

## Dependency management
var dependencies : DependencyDatabase = DependencyDatabase.for_node("States")


## Logic to be executed when node is ready
func _ready() -> void:
	dependencies.add("actor", actor)
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return
	
	_connect_signals()
	_register_states()
	
	call_deferred("transition", initial_state)


## Connect the necessary signals 
func _connect_signals() -> void:
	TimeManager.tick_reached.connect(_tick_process)
	state_change_requested.connect(transition)


## Register child states as usable states
func _register_states() -> void:
	
	var children : Array[Node] = get_children()
	for child in children:
		if _is_state(child) and child.is_enabled():
			states[child.name.to_lower()] = child
			child.actor = actor
			child.enter_requested.connect(transition)
			child.exit_requested.connect(handle_state_exit_request)


## Get if node is a state
func _is_state(node :  Node) -> bool:
	return node is State


## Exit from the state to next if possible (initial_state will be used if no next state provided)
func handle_state_exit_request(_state : State) -> void: 
	
	# if no next state was provided, initial_state
	if initial_state:
		transition(initial_state)


## Transition between current state and the new one
func transition(new_state : State) -> void:

	if not new_state or not states.has(new_state.name.to_lower()) or not new_state.is_enabled():
		return

	if current_state:
		print("Exiting state %s" % current_state.name)
		current_state.exit()
	
	print("Entering state %s" % new_state.name)
	
	new_state.enter()
	current_state = new_state


## Process logic
func _process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.process(delta)


## Physics logic
func _physics_process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.physics(delta)


## Tick process logic 
func _tick_process() -> void:
	if not current_state:
		return
		
	current_state.tick()
