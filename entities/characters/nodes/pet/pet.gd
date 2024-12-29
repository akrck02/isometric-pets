class_name Pet
extends CharacterBody2D

## Pet data
@export_category("Stats")
@export var pet_name : String = "tas"
@export var location : World.Locations = World.Locations.MainSquare
@export var stats : CareStats = CareStats.new()

## Visuals
@onready var sprite : Sprite2D = $Visuals/Sprite
@onready var point_light : PointLight2D = $Visuals/PointLight2D
@onready var animation_player : AnimationPlayer = $Visuals/AnimationPlayer

## Emotions
@onready var chat_bubble = $Visuals/ChatBubble

## Interactions
@onready var interaction_area : Area2D = $Interaction
var interaction_active : bool  = false

## Loader
@onready var loader : PetLoader = $Loader


## Called when the node enters the scene tree for the first time.
func _ready():
	_load_from_savestate();
	_update_sprite()
	_connect_signals()
	
	stats.hunger = 80
	stats.fun = 17
	stats.affection = 17


## Connect signals
func _connect_signals():
	TimeManager.tick_reached.connect(_tick_update)
	TimeManager.night_started.connect(_set_night)
	TimeManager.day_started.connect(_set_day)
	NfcManager.pet_change_requested.connect(_change_pet)
	interaction_area.input_event.connect(_handle_interaction)


## This function will be called every tick
func _tick_update():
	stats.time += 1


## Load pet data from savestate
func _load_from_savestate():
	
	var pet_data : Dictionary = SaveManager.save_data.pets[pet_name]
	
	if pet_data != null: 
		stats = CareStats.from_dictionary(pet_data.stats);
		location = pet_data.location
		if pet_data.has("uuid"): loader.uuid = pet_data.uuid


## Change the sprite according to name
func _update_sprite():
	if not sprite:
		return;
	sprite.texture = load(Paths.get_character("pet").get_sprite("%s.png" % pet_name))


## Change the pet by uuid
func _change_pet(uuid : String) -> void:
	loader.loaded = loader.uuid == uuid
	loader.uuid = uuid
	loader.load_pet_requested.emit()


## Handle interaction
func _handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	
	if event is not InputEventScreenTouch:
		return;
	
	_handle_touch(event)


## Handle touch interaction
func _handle_touch(event : InputEventScreenTouch):
	
	if not event.double_tap:
		return
	
	InteractionManager.stop_interactions()
	interaction_active = !interaction_active
	
	if interaction_active:
		InteractionManager.interact_with_pet(self)



## Play animation based in mood
func play_mood_animation():
	match stats.mood:
		CareEnums.Mood.HAPPY : animation_player.play("happy")
		CareEnums.Mood.ANGRY : animation_player.play("angry")
		CareEnums.Mood.HUNGRY : animation_player.play("hungry")
		CareEnums.Mood.SAD : animation_player.play("sad")


## Prepare the visuals for nighttime
func _set_night() : 
	point_light.show()


## Prepare the visuals for daytime
func _set_day() : 
	point_light.hide()


## Toggle the sprite outline
func set_outline(value:bool):
	if value:
		sprite.material = load("res://materials/general/outline_shader_material.tres")
		return
		
	sprite.material = null


## Save the pet as dictionary
func save() -> Dictionary:
	var data = {}
	var coords = TilemapManager.get_coordinates_from_global_position(global_position)
	
	if null != loader: data.uuid = loader.uuid
	data.name = pet_name
	data.location = location
	data.coordinates = {}
	data.coordinates.x = coords.x
	data.coordinates.y = coords.y
	data.stats = stats.to_dictionary()
	return data
