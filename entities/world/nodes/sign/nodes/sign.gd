extends Node2D

@export var scene : String = "park"
@export var scene_type : SceneEnums.Type = SceneEnums.Type.World
@onready var area_2d : Area2D = $Area2D
var change_requested = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.input_event.connect(handle_input)

# Handle input
func handle_input(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	
	if change_requested or !Input.is_action_just_pressed("ui_accept"):
		return
	
	var path : String = ""
	match scene_type:
		SceneEnums.Type.World:
			path = Paths.get_world().get_scene()
		SceneEnums.Type.Interior:
			path = Paths.get_interior(scene).get_scene()
		SceneEnums.Type.Minigame:
			path = Paths.get_minigame(scene).get_scene()
		SceneEnums.Type.Debug:
			path = Paths.get_debug_scene(scene).get_scene()
	
	if path != "" :
		SignalDatabase.scene_change_requested.emit(path)
	
	change_requested = true
