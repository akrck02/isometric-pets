extends Node

## Signals
signal tilemap_changed(tilemap : TileMap)

## Registered tilemaps
@onready var tilemap : TileMapExtended = _create_fallback_tilemap()


## Logic to be executed when node is ready
func _ready() -> void:
	tilemap_changed.connect(set_tilemap)


## Set current tilemap
func set_tilemap(new_tilemap: TileMapExtended):
	tilemap = new_tilemap


## Create a fallback tilemap
func _create_fallback_tilemap() -> TileMapExtended:
	
	var fallback_layer = TileMapLayer.new()
	fallback_layer.tile_set = preload('res://materials/map/tilemap.tres')

	var fallback = TileMapExtended.new()
	fallback.layers.append(fallback_layer)
	return fallback


## Get coordinates from global position
func get_coordinates_from_global_position(global_position : Vector2i) -> Vector2i:
	return tilemap.get_coordinates_from_global_position(global_position)


## Get global position from coordinates
func get_global_position_from_coordinates(coordinates : Vector2i) -> Vector2i:
	return tilemap.get_global_position_from_coordinates(coordinates)
