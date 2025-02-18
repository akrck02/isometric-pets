class_name Card
extends Node2D

const movement_speed = 1.00 / 1.5
var number: int = -1
var color: Color
@onready var front_panel: Panel = $FrontPanel

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D


## If the number and color is shown
var show_card: bool = false

## If card is selected
var selected: bool = false

## If user can select this card
var selectable: bool = false

func _ready() -> void:
	area_2d.input_event.connect(handle_interaction)
	name = str(color) + " " + str(number)
	update_sprite()
	
func _init() -> void:
	pass
	

func _to_string() -> String:
	return "{0} {1}".format([color, number])


func handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	print(1)
	if event is not InputEventScreenTouch and event.is_pressed() == false:
		return ;
	
	if not selectable:
		return
	
	selected = !selected
	print("1")
	if selected:
		select()
	else:
		unselect()
		
func select():
	animation_player.play("select")
	
func unselect():
	animation_player.play("idle")

func set_show(value: bool):
	if show_card!=value:
		if value:
			animation_player.play("show")
		else:
			animation_player.play("hide")
	show_card = value

func set_selectable(value: bool):
	self.selectable = value


func update_sprite():
	
	if not front_panel:
		return
		
	if not label:
		return
		
	label.text = str(number)
	var stylebox:StyleBox=front_panel.get_theme_stylebox("panel").duplicate()
	stylebox.bg_color=color
	front_panel.add_theme_stylebox_override("panel", stylebox)
	
	if show_card:
		#label.show()
		animation_player.play("show")
	else:
		animation_player.play("hide")
		#label.hide()
		#color_rect.color = Color(1, 1, 1)
