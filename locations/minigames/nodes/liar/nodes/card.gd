class_name Card
extends Node2D

const movement_speed = 1.00 / 1.5
var number: int = -1
var color: Color

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var panel: Panel = $Panel
@onready var area_2d: Area2D = $ColorRect/Area2D


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
	if event is not InputEventScreenTouch and event.is_pressed() == false:
		return ;
	
		
	if not selectable:
		return
	
	selected = !selected
	
	if selected:
		print("Selected card")
		select()
	else:
		unselect()
		
func select():
	set_outline(true)
	
func unselect():
	set_outline(false)
		

func set_outline(value: bool):
	# TODO 	
	var styleBox: StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()
	if value:
		
		styleBox.set("border_color", Color(1, 1, 1))
		styleBox.set_border_width_all(10)
	else:
		styleBox.set("border_color", Color(0, 0, 0))
		styleBox.set_border_width_all(5)
	panel.add_theme_stylebox_override("panel", styleBox)
	

func set_show(value: bool):
	show_card = value
	update_sprite()

func set_selectable(value: bool):
	self.selectable = value


func update_sprite():
	
	if not color_rect:
		return
		
	if not label:
		return
		
		
	label.text = str(number)
	color_rect.color = color
		
	if show_card:
		label.show()
	else:
		label.hide()
		color_rect.color = Color(1, 1, 1)
