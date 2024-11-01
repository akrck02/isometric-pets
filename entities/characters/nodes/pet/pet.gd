class_name Pet
extends CharacterBody2D

# Pet data
@export_category("Stats")
@export var pet_name : String = "tas"
@export var stats : PetStats

# Visuals
@onready var sprite : Sprite2D = $Visuals/Sprite
@onready var point_light : PointLight2D = $Visuals/PointLight2D

# Emotions
@onready var chat_bubble = $Visuals/ChatBubble

# Interactions
@onready var interaction_area : Area2D = $Interaction
var interaction_active : bool  = false

## Called when the node enters the scene tree for the first time.
func _ready():
	_load_from_savestate();
	_update_sprite()

	TimeManager.tick_reached.connect(_tick_update)
	TimeManager.night_started.connect(_set_night)
	TimeManager.day_started.connect(_set_day)
	
	# Interactions
	interaction_area.input_event.connect(_handle_interaction)
	
	# Set outline based on config file
	_toggle_outline(false)


## Load pet data from savestate
func _load_from_savestate():
	stats = PetStats.new();


## Change the sprite according to name
func _update_sprite():
	if not sprite:
		return;
	sprite.texture = load(Paths.get_character("pet").get_sprite("%s.png" % pet_name))


## Handle interaction
func _handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	
	if event is not InputEventScreenTouch:
		return;
		
	_handle_touch(event)


## Handle touch interaction
func _handle_touch(event : InputEventScreenTouch):
	
	if not event.double_tap:
		return
	
	interaction_active = !interaction_active
	
	if interaction_active:
		UIManager.notification_shown.emit("[center] %s is interested" % pet_name)
		InputManager.context = Game.Context.PetInteraction
		sprite.material.set_shader_parameter("width",2)
	else:
		InputManager.context = Game.Context.Camera
		sprite.material.set_shader_parameter("width",0)
		

## This function will be called every tick
func _tick_update():
	stats.time += 1
	_normalize_stats()
	_show_feelings()


## Normalize stat values
func _normalize_stats():
	stats.hunger = clamp(stats.hunger,0,100)
	stats.affection = clamp(stats.affection,0,100)
	stats.energy =  clamp(stats.energy,0,100)
	stats.fun =  clamp(stats.fun,0,100)


## Prepare the visuals for nighttime
func _set_night() : 
	point_light.show()


## Prepare the visuals for daytime
func _set_day() : 
	point_light.hide()


# Toggle the sprite outline
func _toggle_outline(value:bool):
	if value:
		sprite.material.set_shader_parameter("width",1)
		return
		
	sprite.material.set_shader_parameter("width",0)


## Interact
func _interact():
	pass


## Show feelings 
func _show_feelings():
	if stats.hunger > 80:
		chat_bubble.visible = true
