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
	# InputManager.screen_touch_double_tap.connect(move_test)
	SignalDatabase.tick_reached.connect(tick_process)
	SignalDatabase.outline.connect(toggle_outline)
	
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
	# navigation.step()


## Set idle state
func idle() -> void:
	animation_player.play("idle")


## Test click movement
func move_test(input: InputData) -> void:
	var click_coordinates : Vector2i = TilemapManager.get_coordinates_from_global_position(input.get_current_global_position(get_viewport()))
	navigation.calculate_path_to(click_coordinates)


## Move towards coordinates in grid
func move_towards_in_grid(new_coordinates : Vector2i) -> void:
	
	if new_coordinates == null:
		return;
		
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
	# if not SceneManager.current_tilemap.can_object_be_placed_on_tile(self, coords):
		# return
	
	var directions : Array[MoveEnums.Direction] = Positions.get_directions_from_coordinates(navigation.coordinates, new_coordinates)

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

	navigation.step_node_to(self,new_coordinates)

## Interact
func interact() -> void:
	pass

## Toggle outline
func toggle_outline(value : bool) -> void:
	if value:
		sprite.material.set_shader_parameter("width",1)
		return
		
	sprite.material.set_shader_parameter("width",0)
