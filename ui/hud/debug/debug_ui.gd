extends Control
class_name DebugUi

# Initial parameters
@export var camera : Camera2D

# UI labels
@onready var coordinates_label : Label = $CoordinatesLabel
@onready var position_label : Label = $LocalPositionLabel
@onready var global_position_label : Label = $GlobalPositionLabel


## Physics process logic
func _physics_process(_delta: float) -> void:
	
	if not camera:
		return
	
	update_debug_data(get_global_mouse_position())


## Update coordinates on labels
func update_debug_data(global_mouse_position : Vector2):
		
	var new_global_position = Positions.convert_ui_position_to_scene_global_position(get_viewport(), global_mouse_position)
	var camera_local_position : Vector2i = camera.to_local(new_global_position)
	# var tilemap_local_position : Vector2i =  TilemapManager.get_(new_global_position)
	var coordinates : Vector2i = TilemapManager.get_coordinates_from_global_position(new_global_position)

	coordinates_label.text      = "Coords: x: {x} , y: {y}".format({"x" : coordinates.x, "y": coordinates.y})
	position_label.text         = "Camera: x: {x} , y: {y}".format({"x" : camera_local_position.x, "y": camera_local_position.y})
	global_position_label.text  = "Global: x: {x} , y: {y}".format({"x" : "%d" % new_global_position.x, "y": "%d" % new_global_position.y})
