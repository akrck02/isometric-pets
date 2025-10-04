extends Node2D
class_name DinoRunCharacter

## Pet
var current_pet_name : String = ""

## Motion parameters
@export var global_speed : float = 1;
var capture_motion = true

## Visuals
@onready var timer : Timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite

## jump
@onready var original_position : Vector2 = position
@onready var tween : Tween
@export var jump_speed = .15;
var jumping : bool = false

## Collisions
@onready var collision_area : Area2D = $Area2D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_area.area_entered.connect(check_collision)
	animation_player.play("walk")


## Controls 
func _input(_event):
	if Input.is_action_just_pressed(Controls.INTERACT):
		_jump()


## Handle input
func _jump():
	
	if not capture_motion or jumping:
		return

	jumping = true
	tween = create_tween()
	tween.tween_property(self, NodeProperties.Position, original_position + (Vector2.UP * 60), jump_speed * .7).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	tween.kill()
	
	# wait here
	timer.wait_time = jump_speed * 1.2
	timer.start()
	await timer.timeout
	
	tween = create_tween()
	tween.tween_property(self, NodeProperties.Position, original_position, jump_speed * 2).set_trans(Tween.TRANS_SINE)
	await tween.finished
	tween.kill()
	jumping = false


## Check colisions
func check_collision(node : Node2D):
	
	if node.is_in_group("dino_run_score_area"):
		_update_score()
	elif node.is_in_group("dino_run_death_area"):
		_kill()


## Update score
func _update_score():
	SignalDatabase.dinorun_update_score.emit()


## Kill dino
func _kill():
	SignalDatabase.dinorun_finished.emit()


## Set pet
func set_pet(pet_name : String) -> void: 
	if not SaveManager.save_data.pet_exists(pet_name):
		return 

	current_pet_name = pet_name
	sprite.texture = load(Paths.get_pets().get_sprite("%s.png" % pet_name))
