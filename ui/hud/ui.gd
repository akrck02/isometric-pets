extends CanvasLayer

# Dependency injection
@export var site_name : String = "" 
@export var camera : SmartCamera

# Ui general
@onready var ui_control : VBoxContainer = $UiControl
@onready var time_label : Label = $UiControl/PanelContainer/MarginContainer/Banner/Time 
@onready var filter : ColorRect = $Filter
@onready var loader_animation : AnimationPlayer = $Loader/AnimationPlayer

# Info banner
@onready var info_banner : PanelContainer = $UiControl/MarginContainer/InfoBanner
@onready var info : RichTextLabel = $UiControl/MarginContainer/InfoBanner/Info
@onready var info_animation_player : AnimationPlayer = $UiControl/MarginContainer/InfoBanner/AnimationPlayer
@onready var info_timer : Timer = $UiControl/MarginContainer/InfoBanner/Timer
var notification_showing = false;

# Settings
@onready var show_settings_button : Button = $UiControl/PanelContainer/MarginContainer/Banner/SettingsButton/Button
@onready var settings = $Settings

# Location title
@onready var location_label : Label = $UiControl/PanelContainer/MarginContainer/Banner/LocationContainer/Location 

# Debug ui
@onready var debug_ui : DebugUi = $Debug

# Dependency management
var dependencies : DependencyDatabase = DependencyDatabase.for_node("Ui")


## Called when the node enters the scene tree for the first time.
func _ready():
	dependencies.add("camera", camera)
	
	if not dependencies.check():
		Nodes.stop_node_logic_process(self)
		return

	debug_ui.camera = camera
	
	_connect_signals()
	_update_time()
	location_label.text = site_name
	loader_animation.play("idle")
		
	#if OSManager.is_desktop():
	#	info_banner.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN


## Process inputs
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&'ui_debug'):
		debug_ui.visible =! debug_ui.visible


## Connect the needed signals
func _connect_signals():
	TimeManager.tick_reached.connect(_update_tick);
	TimeManager.night_started.connect(_set_night_color_palette)
	TimeManager.day_started.connect(_set_day_color_palette)
	
	UIManager.notification_shown.connect(_show_notification)
	UIManager.notification_hidden.connect(_hide_notification)
	
	show_settings_button.pressed.connect(_toggle_settings)
	InputManager.start_requested.connect(_toggle_settings_by_input)
	
	SaveManager.save_game_started.connect(_start_loader_animation)
	SaveManager.save_game_finished.connect(_finish_loader_animation)
	
	UIManager.interaction_started.connect(_target_camera)


## Target the camera to the current selected pet
func _target_camera():
	camera.focus_node = InteractionManager.current_pet
	camera.focus()
	camera.return_to_default_camera_position(null)


## Toggle the entire ui visibility
func _toggle_ui():
	ui_control.visible = !ui_control.visible


## Update tick
func _update_tick():
	_update_time()


## Update time clock
func _update_time():
	var time = TimeManager.get_real_time();
	time_label.text = "{hh}:{mm}".format({"hh": "%02d" % time.hour, "mm": "%02d" % time.minute })
	TimeManager.emit_daytime()

	
## Set night color palette
func _set_night_color_palette():
	filter.material = load("res://materials/camera/filter_shader_material_night.tres")


## Set day color palette
func _set_day_color_palette():
	filter.material = load("res://materials/camera/filter_shader_material_day.tres")


## Show notification
func _show_notification(message : String):
	
	if notification_showing and info.text == message: 
		return
	
	info.text = message
	info_animation_player.play("notification_in")
	notification_showing = true


## Hide notification
func _hide_notification():
	
	if not notification_showing:
		return
	
	info_animation_player.play("notification_out")
	info.text = ""
	notification_showing = false


## Toggle settings by input
func _toggle_settings_by_input(_data : InputData):
	_toggle_settings()
	

## Toggle settings 
func _toggle_settings():
	
	if settings.visible:
		settings.close_menu()
		return
	
	settings.open_menu()


## Start loader animation
func _start_loader_animation():
	loader_animation.play("load")


## Finish loader animation
func _finish_loader_animation():
	await get_tree().create_timer(1.0).timeout
	loader_animation.play("RESET")
