extends Node2D
class_name TileMapExtended

@onready var layers_container = $Layers
var layers : Array[TileMapLayer]

## On ready 
func _ready() -> void:
	_setup_layer_container()
	_setup_layers()
	
	await get_tree().physics_frame
	# _add_obstacles_to_navigation_map()


## Add obstacles to navigation map
func _add_obstacles_to_navigation_map() -> void:
	
	# get obstacles for each layer
	var obstacles : Array[Vector2i] = []
	for layer : TileMapLayer in layers:
		for cell : Vector2i in layer.get_used_cells():
			var cell_data : TileData = layer.get_cell_tile_data(cell)
			
			if cell_data.get_custom_data("navigation_type") == "wall":
				obstacles.append(cell)
		
	# clear navigation
	print(layers[0].name)
	for obstacle in obstacles:
		var cell_data = layers[0].get_cell_tile_data(obstacle)
		cell_data.modulate = Color.CRIMSON

		


## Create a layer container if not present
func _setup_layer_container() -> void:
	if layers_container != null:
		return
		
	push_warning("A layer container called 'Layers' must be created as child of an ExtendedTileMap, creating automatically to assure the correct execution")
	layers_container = Node2D.new()
	layers_container.name = "Layers"
	add_child(layers_container)


## Get the layers
func _setup_layers() -> void:
	var children = layers_container.get_children()
	for node : Node in children:
		if node is TileMapLayer:
			layers.append(node as TileMapLayer)


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
