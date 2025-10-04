class_name Pet
extends CharacterBody2D

## Pet data
@export_category("Stats")
@export var pet_name : String = "tas"
@export var location : World.Locations = World.Locations.MainSquare
@export var stats : CareStats = CareStats.new()

## Emotions
@onready var chat_bubble = $Visuals/ChatBubble

## Interactions
@onready var interaction_area : Area2D = $Interaction
var interaction_active : bool  = false

## Loader
@onready var loader : PetLoader = $Loader

## Visuals
@onready var visuals: PetVisuals = $Visuals

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_from_savestate()
	_update_sprite()
	_connect_signals()


## Connect signals
func _connect_signals() -> void:
	TimeManager.tick_reached.connect(_tick_update)
	TimeManager.night_started.connect(_set_night)
	TimeManager.day_started.connect(_set_day)
	NfcManager.pet_change_requested.connect(_change_pet)
	interaction_area.input_event.connect(_handle_interaction)


## This function will be called every tick
func _tick_update() -> void:
	stats.time += 1


## Load pet data from savestate
func _load_from_savestate() -> void:
	
	var pet_data : Dictionary = SaveManager.save_data.pets[pet_name]
	if pet_data == null: 
		return
	
	stats = CareStats.from_dictionary(pet_data.stats)
	location = pet_data.location
	if pet_data.has("uuid"): 
		loader.uuid = pet_data.uuid


## Change the sprite according to name
func _update_sprite() -> void:
	visuals._update_sprite()


## Change the pet by uuid
func _change_pet(uuid : String) -> void:
	loader.loaded = loader.uuid == uuid
	loader.uuid = uuid
	loader.load_pet_requested.emit()


## Handle interaction
func _handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if event is not InputEventScreenTouch:
		return
	
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
	visuals.play_mood_animation()

## Prepare the visuals for nighttime
func _set_night() : 
	visuals._set_night()


## Prepare the visuals for daytime
func _set_day() : 
	visuals._set_day()


## Toggle the sprite outline
func set_outline(value:bool):
	visuals.set_outline(value)


## Save the pet as dictionary
func save() -> Dictionary:
	var data = {}
	var coords = TilemapManager.get_coordinates_from_global_position(global_position)
	
	if null != loader: 
		data.uuid = loader.uuid
	
	data.name = pet_name
	data.location = location
	data.coordinates = {}
	data.coordinates.x = coords.x
	data.coordinates.y = coords.y
	data.stats = stats.to_dictionary()
	return data
