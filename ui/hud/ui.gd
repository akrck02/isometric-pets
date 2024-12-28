extends CanvasLayer

# Dependency injection
@export var site_name : String = "" 
@export var camera : SmartCamera

# Ui general
@onready var filter : ColorRect = $Filter
@onready var time_label : Label = $TopBar/MarginContainer/Banner/Spacing/Time
@onready var loader_animation : AnimationPlayer = $Loader/AnimationPlayer

# Info banner
@onready var info_banner : PanelContainer = $MessageContainer/InfoBanner
@onready var info : RichTextLabel = $MessageContainer/InfoBanner/Info
@onready var info_animation_player : AnimationPlayer = $MessageContainer/InfoBanner/AnimationPlayer
@onready var info_timer : Timer = $MessageContainer/InfoBanner/Timer
var notification_showing = false;

# Apps
@onready var apps = $Apps

# Location title
@onready var location_label : Label = $TopBar/MarginContainer/Banner/LocationContainer/Location

# Debug ui
@onready var debug_ui : DebugUi = $Debug

# Dependency management
var dependencies : DependencyDatabase = DependencyDatabase.for_node("Ui")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dependencies.add("camera", camera)
	
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return

	debug_ui.camera = camera
	
	_connect_signals()
	_update_time()
	
	location_label.text = site_name
	loader_animation.play("idle")


## Process inputs
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&'ui_debug'):
		debug_ui.visible =! debug_ui.visible


## Connect the needed signals
func _connect_signals() -> void:
	TimeManager.tick_reached.connect(_update_tick);
	TimeManager.night_started.connect(_set_night_color_palette)
	TimeManager.day_started.connect(_set_day_color_palette)
	
	UIManager.notification_shown.connect(_show_notification)
	UIManager.notification_hidden.connect(_hide_notification)
	
	SaveManager.save_game_started.connect(_start_loader_animation)
	SaveManager.save_game_finished.connect(_finish_loader_animation)
	
	UIManager.interaction_started.connect(_target_camera)
	UIManager.dialogue_started.connect(_target_camera)


## Target the camera to the current selected pet
func _target_camera() -> void:
	
	if null != InteractionManager.current_pet: camera.focus_node = InteractionManager.current_pet
	elif null != InteractionManager.current_npc: camera.focus_node = InteractionManager.current_npc
	camera.focus()
	camera.return_to_default_camera_position(null)
	

## Update tick
func _update_tick() -> void:
	_update_time()


## Update time clock
func _update_time() -> void:
	var time = TimeManager.get_real_time();
	time_label.text = "{hh}:{mm}".format({"hh": "%02d" % time.hour, "mm": "%02d" % time.minute })
	TimeManager.emit_daytime()


## Set night color palette
func _set_night_color_palette() -> void:
	filter.material = load("res://materials/camera/filter_shader_material_night.tres")


## Set day color palette
func _set_day_color_palette() -> void:
	filter.material = load("res://materials/camera/filter_shader_material_day.tres")


## Show notification
func _show_notification(message : String) -> void:
	
	if notification_showing and info.text == message: 
		return
	
	info.text = message
	info_animation_player.play("notification_in")
	notification_showing = true


## Hide notification
func _hide_notification() -> void:
	
	if not notification_showing:
		return
	
	info_animation_player.play("notification_out")
	info.text = ""
	notification_showing = false


## Start loader animation
func _start_loader_animation() -> void:
	loader_animation.play("load")


## Finish loader animation
func _finish_loader_animation() -> void:
	await get_tree().create_timer(1.0).timeout
	loader_animation.play("RESET")
