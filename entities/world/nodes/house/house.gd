extends Node2D

@export  var interactable: bool = false 
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var area_2d : Area2D = $Area2D

func _ready():
	if interactable:
		area_2d.input_event.connect(_on_touch)

func enter_home():
	animation_player.play("enter")
	await animation_player.animation_finished
	SignalDatabase.scene_change_requested.emit(Paths.get_interior("home").get_scene())

func _on_touch(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventScreenTouch:
		return;
	
	handle_touch(event)
	

func handle_touch(event : InputEventScreenTouch):
	if event.double_tap:
		enter_home();
