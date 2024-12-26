class_name Npc
extends CharacterBody2D

## Runtime guard
@onready var dependencies : DependencyDatabase = DependencyDatabase.for_node(name)

# Dependency injection
@export var tilemap : TileMapExtended 

# Pet data
@export var character_name : String = "soriel"

# Visuals
@onready var visuals : Node2D = $Visuals
@onready var sprite : Sprite2D = $Visuals/Sprite

# Movement
@onready var animation_player : AnimationPlayer = $Visuals/AnimationPlayer

# Navigation
@onready var navigation : NavigationNode = $Navigation

# Interactions
@onready var interaction_area : Area2D = $Interaction

# Dialogue
@onready var dialogue : Dialogue = $Dialogue

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return
	
	# Signal connection
	TimeManager.tick_reached.connect(tick_process)
	set_outline(false)
	
	# Interactions
	interaction_area.input_event.connect(_handle_interaction)
	
	# Setup the npc data
	load_from_savestate();
	dialogue.load_for_character(character_name)
	update_sprite()
	idle()
	

## load pet data from savestate
func load_from_savestate() -> void:
	pass
	
	
## Change the sprite according to name
func update_sprite() -> void:
	if not sprite:
		return;
	
	sprite.texture =  load(Paths.get_character("npc").get_sprite("%s.png" % character_name))


## This function will be called every tick
func tick_process() -> void:
	pass


## Set idle state
func idle() -> void:
	animation_player.play("idle")


## Handle interaction
func _handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	
	if event is not InputEventScreenTouch:
		return;
	
	if not event.double_tap:
		return
	
	InteractionManager.interact_with_npc(self)


## Set sprite outline
func set_outline(value:bool):
	if value:
		sprite.material = load("res://materials/general/outline_shader_material.tres")
		return
		
	sprite.material = null
