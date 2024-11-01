extends Node2D

@onready var exit_area : Area2D = $ExitArea

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_area.input_event.connect(exit)


## Exit to map
func exit(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if event is not InputEventScreenTouch:
		return;
	
	if not event.double_tap:
		return 
	
	SceneManager.scene_change_requested.emit(Paths.get_world().get_scene())
	queue_free()
