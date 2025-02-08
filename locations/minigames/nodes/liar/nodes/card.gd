class_name Card
extends Node2D

const movement_speed = 1.00 / 1.5
@export var number: int
@export var color: String
@export var facing: Constants.FACING

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	animation_player.play("idle")
	set_outline(true)
	
func unselect():
	animation_player.play("RESET")
	set_outline(false)
		
func show_card_sprite():
	update_sprite()

func set_outline(value:bool):
	
	if value:
		sprite_2d.material=load("res://locations/minigames/nodes/liar/materials/card_selected_material.tres")
		sprite_2d.material.set_shader_parameter("width",3)
		return
	
	sprite_2d.material=null
	

func set_facing(facing: Constants.FACING):
	self.facing = facing
	update_sprite()


func set_reveal(value: bool):
	self.reveal = value

	update_sprite()

func set_selectable(value: bool):
	self.selectable=value


func update_sprite():
	
	if not sprite_2d:
		return
	
	sprite_2d.frame=0
	var frame_cords_x=0

	if self.reveal:
		sprite_2d.texture = load(Paths.get_minigame("liar").get_sprite("%s_cards.png" % color))
		sprite_2d.hframes = 10
		sprite_2d.vframes = 2
		frame_cords_x=self.number
	else:
		sprite_2d.texture = load(Paths.get_minigame("liar").get_sprite("white_card.png"))
		sprite_2d.hframes = 1
		sprite_2d.vframes = 2

	# Set facing of card
	match self.facing:
		Constants.FACING.DOWN:
			rotation_degrees = 0
			sprite_2d.frame_coords = Vector2i(frame_cords_x, 0)
		Constants.FACING.UP:
			rotation_degrees = 180
			sprite_2d.frame_coords = Vector2i(frame_cords_x, 0)
		Constants.FACING.RIGHT:
			rotation_degrees = 0
			sprite_2d.frame_coords = Vector2i(frame_cords_x, 1)
		Constants.FACING.LEFT:
			rotation_degrees = 180
			sprite_2d.frame_coords = Vector2i(frame_cords_x, 1)
