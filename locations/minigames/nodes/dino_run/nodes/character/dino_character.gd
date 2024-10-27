extends Node2D
class_name DinoRunCharacter

# Motion parameters
@export var global_speed : float = 1;
var capture_motion = true

# Animations
@onready var timer : Timer = $Timer
@onready var animation_player = $AnimationPlayer

# jump
@onready var original_position : Vector2 = position
@onready var tween : Tween
@export var jump_speed = .15;
var jumping : bool = false


@onready var area_2d : Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputManager.screen_touch_started.connect(jump)
	area_2d.area_entered.connect(check_collision)
	animation_player.play("walk")

func _input(_event):
	if Input.is_action_just_pressed(Controls.INTERACT):
		jump(null)

# Handle input
func jump(_data : InputData):
	
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

func check_collision(node : Node2D):
	
	if node.is_in_group("dino_run_score_area"):
		update_score()
	elif node.is_in_group("dino_run_death_area"):
		kill()

func update_score():
	SignalDatabase.dinorun_update_score.emit()

func kill():
	SignalDatabase.dinorun_finished.emit()
