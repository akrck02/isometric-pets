extends CanvasLayer

# Dependency injection
@export var site_name : String = "" 
@export var camera : Camera2D

# Ui general
@onready var ui_control : VBoxContainer = $UiControl
@onready var time_label : RichTextLabel = $UiControl/PanelContainer/MarginContainer/Banner/Time 
@onready var filter : ColorRect = $Filter

# Info banner
@onready var info : RichTextLabel = $UiControl/MarginContainer/InfoBanner/Info
@onready var info_animation_player : AnimationPlayer = $UiControl/MarginContainer/InfoBanner/AnimationPlayer
@onready var info_timer : Timer = $UiControl/MarginContainer/InfoBanner/Timer
var notification_showing = false;

# Settings
@onready var show_settings_button : Button = $UiControl/ShowSettings/Control/Button
@onready var settings = $Settings

# Location title
@onready var location_label : RichTextLabel = $UiControl/PanelContainer/MarginContainer/Banner/Location

# Debug ui
@onready var debug_ui : DebugUi = $DebugUi

## Dependency management
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


## Connect the needed signals
func _connect_signals():
	SignalDatabase.tick_reached.connect(_update_tick);
	SignalDatabase.night_started.connect(_set_night_color_palette)
	SignalDatabase.day_started.connect(_set_day_color_palette)
	SignalDatabase.notification_shown.connect(_show_notification)
	SignalDatabase.notification_hidden.connect(_hide_notification)
	InputManager.start_requested.connect(_toggle_settings_by_input)
	show_settings_button.pressed.connect(_toggle_settings)
	

## Toggle the entire ui visibility
func _toggle_ui():
	ui_control.visible = !ui_control.visible


## Update tick
func _update_tick():
	_update_time()


## Update time clock
func _update_time():
	var time = TimeManager.get_real_time();
	time_label.text = "[right] {hh}:{mm}".format({"hh": "%02d" % time.hour, "mm": "%02d" % time.minute })
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
func _toggle_settings_by_input(data : InputData):
	_toggle_settings()
	

## Toggle settings 
func _toggle_settings():
	settings.visible=!settings.visible
	if settings.visible:
		InputManager.context = Game.Context.Settings 
				
