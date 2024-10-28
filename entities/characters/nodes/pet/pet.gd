class_name Pet
extends CharacterBody2D

# Pet data
@export var pet_name : String = "tas"
@export var stats : PetStats

# Visuals
@onready var sprite : Sprite2D = $Sprite
@onready var point_light : PointLight2D = $PointLight2D

# Emotions
@onready var chat_bubble = $ChatBubble

# Movement
@export var control : bool = false;
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var ray : RayCast2D = $RayCast2D
@onready var tween : Tween
@export var movement_speed = 1.00/1.5;
var moving = false

# Interactions
@onready var area_2d : Area2D = $Area2D
var interaction_active : bool  = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_savestate();
	update_sprite()

	SignalDatabase.tick_reached.connect(tick_update)
	SignalDatabase.night_started.connect(set_night)
	SignalDatabase.day_started.connect(set_day)
	SignalDatabase.outline.connect(toggle_outline)
	
	# Interactions
	area_2d.input_event.connect(handle_interaction)
	
	# Set outline based on config file
	animation_player.play("idle")
	toggle_outline(false)

# load pet data from savestate
func load_from_savestate():
	stats = PetStats.new();
	
# Change the sprite according to name
func update_sprite():
	if not sprite:
		return;
	sprite.texture = load(Paths.get_character("pet").get_sprite("%s.png" % pet_name))

# Handle interaction
func handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	
	if event is not InputEventScreenTouch:
		return;
		
	handle_touch(event)

# Handle touch interaction
func handle_touch(event : InputEventScreenTouch):
	
	if not event.double_tap:
		return
	
	interaction_active = !interaction_active
	
	if interaction_active:
		SignalDatabase.notification_shown.emit("[center] %s is interested" % pet_name)
		InputManager.context = Game.Context.PetInteraction
		sprite.material.set_shader_parameter("width",2)
	else:
		InputManager.context = Game.Context.Camera
		sprite.material.set_shader_parameter("width",0)
		

# This function will be called every tick
func tick_update():
	stats.time += 1
	automatic_movement()
	normalize_stats()
	show_feelings()
	

# Normalize stat values
func normalize_stats():
	stats.hunger = clamp(stats.hunger,0,100)
	stats.affection = clamp(stats.affection,0,100)
	stats.energy =  clamp(stats.energy,0,100)
	stats.fun =  clamp(stats.fun,0,100)

# Automatic movement
func automatic_movement():
	
	if control or moving or interaction_active: 
		return
	
	var direction = randi() % 7
	move(direction)


# Move the character
func move(direction : int):

	moving = true
	var length = 40 
	var new_position = Vector2.ZERO 
	match direction:
		1: new_position = length * (Vector2.UP * 0.5 + Vector2.LEFT)    # Left
		2: new_position = length * (Vector2.UP * 0.5 + Vector2.RIGHT)   # Up
		3: new_position = length * (Vector2.DOWN * 0.5 + Vector2.LEFT)  # Down
		4: new_position = length * (Vector2.DOWN * 0.5 + Vector2.RIGHT) # Right
		
	# Check future collisions
	ray.target_position = new_position
	ray.force_raycast_update()
	
	# If a collision will happen, stop
	if not ray.is_colliding() and new_position != Vector2.ZERO:
		stats.energy -= 1
		stats.hunger += 1
		
		animation_player.play("walk")
		tween = create_tween()
		tween.tween_property(self, NodeProperties.Position, position + new_position, movement_speed).set_trans(Tween.TRANS_SINE)
		await tween.finished
		tween.kill()
		animation_player.play("idle")
		
	moving = false

# Prepare the visuals for nighttime
func set_night() : 
	point_light.show()

# Prepare the visuals for daytime
func set_day() : 
	point_light.hide()

# Toggle the sprite outline
func toggle_outline(value:bool):
	if value:
		sprite.material.set_shader_parameter("width",1)
		return
		
	sprite.material.set_shader_parameter("width",0)

# Interact
func interact():
	pass

# Show feelings 
func show_feelings():
	if stats.hunger > 80:
		chat_bubble.visible = true
