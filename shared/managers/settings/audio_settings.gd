extends Node
class_name AudioSettings

static var VOLUME_KEY = "Volume"

## Apply the given configuration
static func apply_current_configuration() -> void:
	change_general_volume(get_general_volume())


## Change the volume of the given bus
static func change_volume(bus : Audio.Bus, value : float) -> void:
	SettingsManager.set_value(VOLUME_KEY, Audio.get_bus_name(bus), value)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

## Change the volume of general bus
static func change_general_volume(value : float) -> void:
	const bus = Audio.Bus.General
	SettingsManager.set_value(VOLUME_KEY, Audio.get_bus_name(bus), value)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


## Get general volume 
static func get_general_volume() -> float:
	return SettingsManager.get_value(VOLUME_KEY, Audio.get_bus_name(Audio.Bus.General))
