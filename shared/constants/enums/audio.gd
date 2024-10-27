extends Node
class_name Audio

enum Bus {
	General,
	Music,
	Effects
}

static var _bus_names = ["General", "Music", "Effects"]

## Get the bus name
static func get_bus_name(bus : Bus) -> String:
	return _bus_names[bus]
