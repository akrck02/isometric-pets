extends Node2D
class_name TileMapExtended

@onready var layers_container = $Layers
var layers : Array[TileMapLayer]

## On ready 
func _ready():
	_setup_layer_container()
	_setup_layers()

## Create a layer container if not present
func _setup_layer_container():
	if layers_container != null:
		return
		
	push_warning("A layer container called 'Layers' must be created as child of an ExtendedTileMap, creating automatically to assure the correct execution")
	layers_container = Node2D.new()
	layers_container.name = "Layers"
	add_child(layers_container)


## Get the layers
func _setup_layers():
	var children = layers_container.get_children()
	for node in children:
		if node is TileMapLayer:
			layers.append(node as TileMapLayer)


## Filter tilemap layer
func filter_tilemap_layer(node : Node) -> bool:
	return node is TileMapLayer


## Get the position inside de grid
func snap_position(origin : Vector2) -> Vector2:
	
	if layers.is_empty():
		push_warning("tile layer not asigned")
		return origin
	
	return layers[0].map_to_local(get_coordinates_from_global_position(origin))


## Get coordinates from global position
func get_coordinates_from_global_position(global_origin : Vector2) -> Vector2i:
	
	if layers.is_empty():
		push_warning("tile layer not asigned")
		return Vector2.ZERO
	
	return layers[0].local_to_map(to_local(global_origin))


## Get global position from coordinates
func get_global_position_from_coordinates(coords : Vector2) -> Vector2:
	
	if layers.is_empty():
		push_warning("tile layer not asigned")
		return Vector2.ZERO
	
	return self.to_global(layers[0].map_to_local(coords))
