extends Control

@export var enable = false
var scene = preload("res://entities/characters/nodes/pet/pet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#InputManager.movement_requested.connect(_add)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if not enable: return
	if (event is InputEventMouse):
		var button = event.get_button_mask()

		if (button == 1):
			var new_global_position = Positions.convert_ui_position_to_scene_global_position(get_viewport(), get_global_mouse_position())
			var coordinates : Vector2i = TilemapManager.get_coordinates_from_global_position(new_global_position)
			var position = TilemapManager.get_global_position_from_coordinates(coordinates)
		
			print("click x:", coordinates.x, ", y:", coordinates.y)
			
			var obj = scene.instantiate() as Node2D
			obj.global_position = Vector2(position.x, position.y)
			TilemapManager.tilemap.add_child(obj)
			#TilemapManager.select(coordinates.x, coordinates.y)
			
func _add(data : InputData):
	var input = data.keyboard_and_mouse_data
	var point = input.direction
	print("click x:", point.x, ", y:", point.y)
