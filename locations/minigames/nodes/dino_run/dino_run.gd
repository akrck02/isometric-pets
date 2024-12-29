extends Node2D

# Parallax
@export var global_speed : float = 1.75;

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
@onready var pet_selector : PetSelector = $ui/PetSelector
@onready var run_score_container : VBoxContainer = $ui/RunScore
@onready var top_score_label : Label = $ui/RunScore/MarginContainer/PanelContainer/Score
@onready var results_container : VBoxContainer = $ui/Results
@onready var results_score_label : Label = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Score/Value

@onready var exit_button : Button = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Buttons/Exit
@onready var retry_button : Button = $ui/Results/PanelContainer/MarginContainer/VBoxContainer/Buttons/Retry

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	run_score_container.visible = true
	results_container.visible = false

	_connect_signals()
	_update_speeds()


## Start the game
func _start_game() -> void: 
	spawn_timer.wait_time = 1
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.start()

## Connect the signals
func _connect_signals() -> void:
	pet_selector.selected.connect(_select_pet)
	SignalDatabase.dinorun_update_score.connect(_update_score)
	SignalDatabase.dinorun_finished.connect(_show_results)
	despawn_area.area_entered.connect(_despawn_enemy)
	exit_button.pressed.connect(_exit)
	retry_button.pressed.connect(_retry)


## Select the pet
func _select_pet(pet_name : String) -> void:
	
	dino.set_pet(pet_name)
	pet_selector.hide()
	pet_selector.selected.disconnect(_select_pet)
	_start_game()


## Spawn an enemy
func _spawn_enemy():
	
	var distance = 460
	var new_position = spawn_area.position;
	new_position.x += distance
	
	var enemy : DinoRunEnemy = dino_enemy_scene.instantiate()
	enemy.global_speed = global_speed
	enemy.type = randi_range(1,2)
	enemy.position = new_position;
	add_child(enemy)
	
	spawned_enemies.append(enemy)
	spawn_timer.wait_time = randf_range(1,1.5) 


## Despawn an enemy
func _despawn_enemy(area : Area2D):
	spawned_enemies.erase(area.get_parent())
	area.get_parent().queue_free()


## Add to score and update.
func _update_score():
	score += 1
	top_score_label.text = "%08d" % score
	global_speed = round_to_dec(1.75 + log(score) / log(10) , 2)
	_update_speeds()


## Round to given decimals
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)


## Update speeds
func _update_speeds():
	dino.global_speed = global_speed
	
	for enemy in spawned_enemies:
		enemy.global_speed = global_speed


## Show results
func _show_results():
	SignalDatabase.dinorun_update_score.disconnect(_update_score)
	spawn_timer.stop()
	
	for enemy in spawned_enemies:
		enemy.queue_free()
	
	dino.capture_motion = false
	
	results_score_label.text = "%08d" % score
	run_score_container.visible = false
	results_container.visible = true


## Exit
func _exit():
	SceneManager.scene_change_requested.emit(Paths.get_world().get_scene())


## Retry
func _retry():
	SceneManager.scene_change_requested.emit(Paths.get_minigame("dino_run").get_scene())
