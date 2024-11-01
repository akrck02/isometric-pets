extends Node2D

# Parallax
@export var global_speed : float = 1.75;
@onready var parallax : Parallax2D = $Rotation/Parallax2D;
@onready var cloud_particles : GPUParticles2D = $CloudParticles

# Spawn parameters
@onready var spawn_area : Area2D = $SpawnArea
@onready var despawn_area : Area2D = $DespawnArea
@onready var spawn_timer : Timer = $SpawnTimer
@onready var dino_enemy_scene = preload("res://locations/minigames/nodes/dino_run/nodes/enemy/enemy.tscn");
var spawned_enemies : Array = [];

# Dino 
@onready var dino : DinoRunCharacter = $Dino

# UI
var score : int = 0
@onready var run_score_container : VBoxContainer = $ui/RunScore
@onready var top_score_label : Label = $ui/RunScore/MarginContainer/PanelContainer/Score
@onready var results_container : VBoxContainer = $ui/Results
@onready var results_score_label : Label = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Score/Value

@onready var exit_button : Button = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Buttons/Exit
@onready var retry_button : Button = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Buttons/Retry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	run_score_container.visible = true
	results_container.visible = false

	SignalDatabase.dinorun_update_score.connect(update_score)
	SignalDatabase.dinorun_finished.connect(show_results)
	despawn_area.area_entered.connect(despawn_enemy)
	exit_button.pressed.connect(exit)
	retry_button.pressed.connect(retry)
	
	update_speeds()
	spawn_timer.wait_time = 1
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()


# Spawn an enemy
func spawn_enemy():
	
	var size = 460
	var new_position = spawn_area.position;
	new_position.x += size
	new_position.y += size * 0.5
	 
	var enemy : DinoRunEnemy = dino_enemy_scene.instantiate()
	enemy.global_speed = global_speed
	enemy.type = randi_range(1,2)
	enemy.position = new_position;
	add_child(enemy)
	
	spawned_enemies.append(enemy)
	spawn_timer.wait_time = randf_range(1,1.5) 

# Despawn an enemy
func despawn_enemy(area : Area2D):
	spawned_enemies.erase(area.get_parent())
	area.get_parent().queue_free()

# Add to score and update.
func update_score():
	score += 1
	top_score_label.text = "%08d" % score
	global_speed = round_to_dec(1.75 + log(score) / log(10) , 2)
	update_speeds()

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func update_speeds():
	dino.global_speed = global_speed
	var autoscroll_speed = Vector2(-160, 0) * global_speed
	autoscroll_speed.x = round_to_dec(autoscroll_speed.x,0)
	parallax.autoscroll = autoscroll_speed 
	
	cloud_particles.process_material.set("gravity", Vector3(-98 * global_speed, -49 * global_speed, 0))
	
	for enemy in spawned_enemies:
		enemy.global_speed = global_speed

func show_results():
	SignalDatabase.dinorun_update_score.disconnect(update_score)
	spawn_timer.stop()
	
	for enemy in spawned_enemies:
		enemy.queue_free()
	
	dino.capture_motion = false
	
	results_score_label.text = "%08d" % score
	run_score_container.visible = false
	results_container.visible = true

func exit():
	SignalDatabase.scene_change_requested.emit(Paths.get_world().get_scene())
	
func retry():
	SignalDatabase.scene_change_requested.emit(Paths.get_minigame("dino_run").get_scene())
