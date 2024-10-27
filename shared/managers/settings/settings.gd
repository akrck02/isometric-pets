extends Node


## General config data
const settings_path = "user://kinokoro.esettings.cfg"
var config = ConfigFile.new()
@onready var response = config.load(settings_path)

## The default settings of the game
var default_settings = {
	"Volume" : { "General" : .5 },
	"Display" : {"Mode" : Display.WindowMode.Fullscreen }
}

## Signals
signal change_volume(bus : Audio.Bus, value : float)
signal change_general_volume(value : float)

signal set_fullscreen()
signal set_windowed_screen()
signal toggle_fullscreen()

## Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()
	gather_config_data()


## Connect the needed settings related signals
func connect_signals():
	change_volume.connect(AudioSettings.change_volume)
	change_general_volume.connect(AudioSettings.change_general_volume)
	
	set_fullscreen.connect(GraphicSettings.set_fullscreen)
	set_windowed_screen.connect(GraphicSettings.set_windowed_screen)
	toggle_fullscreen.connect(GraphicSettings.toggle_fullscreen)


## Gether the config data or create a new one
func gather_config_data():
	if !FileAccess.file_exists(settings_path):
		config = default_settings
		config.save(settings_path)
		
	elif !check_structure():
		config.clear()
		set_default_values()
	
	# Set audio levels
	var current_general_volume = config.get_value("Volume", Audio.get_bus_name(Audio.Bus.General))
	change_general_volume.emit(current_general_volume)
	
	# Set window mode
	match config.get_value("Display", "Mode"):
		Display.WindowMode.Windowed:
			set_windowed_screen.emit()
		Display.WindowMode.Fullscreen:
			set_fullscreen.emit()
	


## Set the default values for settings
func set_default_values():
	for section in default_settings.keys():
		for key in default_settings[section].keys():
			config.set_value(section, key, default_settings[section][key])
			
	config.save(settings_path)


## Check if the structure of the settings match the default settings structure
func check_structure() -> bool:
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
