class_name Card
extends Node2D

const movement_speed = 1.00 / 1.5
@export var number: int
@export var color: String

@onready var area_2d: Area2D = $Area2D
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

## If the number and color is shown
var reveal: bool = false
var user: int = -1

## If card is selected
var selected:bool=false

## If user can select this card
var selectable:bool=false

func _ready() -> void:
	area_2d.input_event.connect(handle_interaction)
	name=str(color)+" "+str(number)
	update_sprite()
	pass


func _to_string() -> String:
	return "{0} {1}".format([color, number])


func handle_interaction(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is not InputEventScreenTouch and event.is_pressed()==false:
		return;
	
	if user!=0:
		return
		
	if not selectable:
		return
		
	selected=!selected
	
	if selected:
		select()
	else:
		unselect()
		
func select():
	set_outline(true)
	
func unselect():
	set_outline(false)
		
func show_card_sprite():
	update_sprite()

func set_outline(value:bool):
	# TODO 	
	pass
	
	

func set_facing(facing: Constants.FACING):
	self.facing = facing
	update_sprite()


func set_reveal(value: bool):
	self.reveal = value

	update_sprite()

func set_selectable(value: bool):
	self.selectable=value


func update_sprite():
	
	if not color_rect or label:
		return
		
	if reveal:
		label.hide()
	
	else:
		label.show()
