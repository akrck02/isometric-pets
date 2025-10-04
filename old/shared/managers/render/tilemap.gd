extends Node

## Signals
signal tilemap_changed(tilemap : TileMap)

## Registered tilemaps
var tilemap : TileMapExtended = _create_fallback_tilemap()


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

## Get the position inside de grid
func snap_position(origin : Vector2) -> Vector2:
	return tilemap.map_to_local(get_coordinates_from_global_position(origin))

func select(x : int, y : int) -> void:
	print(tilemap.name)
	tilemap.layers[0].set_cell(Vector2i(x,y),0, Vector2i(0,0))
