extends Node
class_name AudioSettings

## Change the volume of the given bus
static func change_volume(bus : Audio.Bus, value : float):
	SettingsManager.set_value("Volume", Audio.get_bus_name(bus), value)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


## Change the volume of general bus
static func change_general_volume(value : float):
	const bus = Audio.Bus.General
	SettingsManager.set_value("Volume", Audio.get_bus_name(bus), value)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
