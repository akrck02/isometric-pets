extends Node


## General config data
const settings_path = "user://kinokoro.esettings.cfg"
var config = ConfigFile.new()
@onready var response = config.load(settings_path)

## The default settings of the game
var default_settings = {
	"Volume" : { "General" : .5 },
	"Display" : { 
		"Mode" : Display.WindowMode.Fullscreen,
		"Size" : 1920,
		"Position" : 1080
	}
}

## Signals
signal change_volume(bus : Audio.Bus, value : float)
signal change_general_volume(value : float)

signal set_fullscreen()
signal set_windowed_screen()
signal toggle_fullscreen()

## Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_gather_config_data()
	# get_window().size = Vector2(960,640)


## Connect the needed settings related signals
func _connect_signals():
	change_volume.connect(AudioSettings.change_volume)
	change_general_volume.connect(AudioSettings.change_general_volume)
	
	set_fullscreen.connect(GraphicSettings.set_fullscreen)
	set_windowed_screen.connect(GraphicSettings.set_windowed_screen)
	toggle_fullscreen.connect(GraphicSettings.toggle_fullscreen)


## Gather the config data or create a new one
func _gather_config_data():
	
	# If a previous savefile does exist and 
	# the structure is corrupted create a new one
	var settings_created : bool = _create_setting_file(settings_path);
	if not settings_created and not _check_structure():
		config.clear()
		_set_default_values()
		
	# Set configurations from current file
	AudioSettings.apply_current_configuration()
	GraphicSettings.apply_current_configuration()


## Create a new savefile and return if created
func _create_setting_file(path : String) -> bool:
	
	if FileAccess.file_exists(path):
		return false
		
	config = ConfigFile.new()
	_set_default_values()
	return true


## Set the default values for settings
func _set_default_values():
	for section in default_settings.keys():
		for key in default_settings[section].keys():
			config.set_value(section, key, default_settings[section][key])
			
	config.save(settings_path)


## Check if the structure of the settings match the default settings structure
func _check_structure() -> bool:
	var default_sections = default_settings.keys()
	var config_file_sections = Array(config.get_sections())
	default_sections.sort()
	config_file_sections.sort()
	
	# Check if sections match
	if default_sections != config_file_sections:
		return false
	
	# Check if keys match
	for x in config_file_sections:
		var config_keys=Array(config.get_section_keys(x))
		var default_keys=default_settings[x].keys()
		config_keys.sort()
		default_keys.sort()
		if config_keys!=default_keys:
			return false
		
	return true


## Set the value for given section property
func set_value(section : String, key : String, value : Variant):
	config.set_value(section,key,value)
	config.save(settings_path)


## Get value for given section property
func get_value(section : String, key : String):
	return config.get_value(section, key)

func get_general_volume() -> float:
	return AudioSettings.get_general_volume();
