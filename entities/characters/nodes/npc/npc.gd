class_name Npc
extends CharacterBody2D

## Runtime guard
@onready var dependencies : DependencyDatabase = DependencyDatabase.for_node(name)

# Dependency injection
@export var tilemap : TileMapExtended 

# Pet data
@export var pet_name : String = "soriel"

# Visuals
@onready var visuals : Node2D = $Visuals
@onready var sprite : Sprite2D = $Visuals/Sprite

# Movement
@onready var animation_player : AnimationPlayer = $Visuals/AnimationPlayer

# Navigation
@onready var navigation : NavigationNode = $Navigation

# Interactions
@onready var interaction : Area2D = $Interaction

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return
	
	# Signal connection
	TimeManager.tick_reached.connect(tick_process)
	UIManager.outline.connect(_set_outline)
	
	_set_outline(false)
	
	# Setup the npc data
	load_from_savestate();
	update_sprite()
	idle()
	

## load pet data from savestate
func load_from_savestate() -> void:
	pass
	
	
## Change the sprite according to name
func update_sprite() -> void:
	if not sprite:
		return;
	
	sprite.texture =  load(Paths.get_character("npc").get_sprite("%s.png" % pet_name))


## This function will be called every tick
func tick_process() -> void:
	pass


## Set idle state
func idle() -> void:
	animation_player.play("idle")
	
	
## Interact
func interact() -> void:
	pass


## Set sprite outline
func _set_outline(value:bool):
	if value:
		sprite.material = load("res://materials/general/outline_shader_material.tres")
		return
		
	sprite.material = null
