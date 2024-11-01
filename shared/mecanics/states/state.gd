extends Node
class_name State

## Signal to exit the state 
@warning_ignore("unused_signal") signal enter_requested(current_state : State)

## Signal to enter the state 
@warning_ignore("unused_signal") signal exit_requested(current_state : State)

## Dependency database
@onready var dependencies : DependencyDatabase = DependencyDatabase.for_node(name)

## The actor of the state
var actor : CharacterBody2D
var enabled : bool = true

## If this state is enabled 
## ALERT DO NOT OVERRIDE!!!
func is_enabled() -> bool:
	return enabled and _can_start() and dependencies.check()

## Logic to be executed before the state enters
func enter() -> void: pass

## Logic to be executed before the state exits
func exit() -> void: pass

## Logic for the standard update of the state
func process(_delta : float) -> void: pass

## Logic for the physics update of the state
func physics(_delta: float) -> void: pass

## Logic for the tick update of the state
func tick() -> void: pass

## Check startup parameters
func _can_start() -> bool:
	return true
