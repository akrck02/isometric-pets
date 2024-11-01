class_name Paths

# Project paths
const _ENTITY_PATH = "res://entities"
const _LOCATION_PATH = "res://locations"
const _SHARED_SCRIPT_PATH = "res://shared"

## Get the animal path
static func get_animal(name : String) -> ModulePath:
	return ModulePath.new(_ENTITY_PATH + "/animals").get_child(name)


## Get the character path
static func get_character(name : String) -> ModulePath:
	return ModulePath.new(_ENTITY_PATH + "/characters").get_child(name)

## Get the world entity path
static func get_world_entity(name : String) -> ModulePath:
	return ModulePath.new(_ENTITY_PATH + "/world").get_child(name)

## Get the item path
static func get_item(name : String) -> ModulePath:
	return ModulePath.new(_ENTITY_PATH + "/items").get_child(name)


## Get the minigame path
static func get_minigame(name : String) -> ModulePath:
	return ModulePath.new(_LOCATION_PATH + "/minigames").get_child(name)


## Get the debug scene path
static func get_debug_scene(name : String) -> ModulePath:
	return ModulePath.new(_LOCATION_PATH + "/debug").get_child(name)


## Get the world scene path
static func get_world() -> ModulePath:
	return ModulePath.new(_LOCATION_PATH + "/world")

## Get the interior scene path
static func get_interior(name : String) -> ModulePath:
	return ModulePath.new(_LOCATION_PATH + "/interior").get_child(name)

## Get the shared script path
static func get_shared_script(path : String) -> String:
	return _ENTITY_PATH + path;
