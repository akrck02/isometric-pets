class_name ModulePath


const _SOUNDS_DIRECTORY : String = "sounds"
const _SPRITES_DIRECTORY : String = "sprites"
const _NODES_DIRECTORY : String = "nodes"
const _SCRIPT_EXTENSION : String = ".gd"
const _SCENE_EXTENSION : String = ".tscn"

var _path : String = ""

## Init the object
func _init(new_path : String) -> void:
	_path = new_path

## Get the path 
func get_path() -> String: 
	return _path

## Get the path of a sprite
func get_sprite(filename : String) -> String: 
	return _format_subpath(_SPRITES_DIRECTORY, filename)

## Get the path of a sound
func get_sound(filename : String) -> String: 
	return _format_subpath(_SOUNDS_DIRECTORY, filename)

## Get the entity path of the child 
func get_child(name : String) -> ModulePath: 
	return ModulePath.new(_format_subpath(_NODES_DIRECTORY, name))

## Get the scene for the current path
func get_scene() -> String:
	var node_name = _get_last_path_name(_path);
	return _format_path(node_name + _SCENE_EXTENSION);

## Get the script for the current path
func get_node_script() -> String:
	var node_path : NodePath = _path;
	var node_name = node_path.get_name(node_path.get_name_count() - 1)
	return _format_path(node_name + _SCRIPT_EXTENSION);


## Get the formatted path
func _format_path(filename : String) -> String:
	return "{path}/{filename}".format({
		"path" : _path,
		"filename" : filename
	})


## Get the formatted subpath
func _format_subpath(suffix : String, filename : String) -> String:
	return "{path}/{suffix}/{filename}".format({
		"path" : _path,
		"suffix" : suffix,
		"filename" : filename
	})


## Get the last name of a path
func _get_last_path_name(path : String) -> String:
	return path.get_slice("/",path.get_slice_count("/") - 1)
