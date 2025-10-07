extends Control
class_name InvUiSlot
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label


var slot_item:Item
var item_quantity:int=0


func update(item:Item, quantity:int):
	slot_item=item
	sprite_2d.texture=item.item_texture
	sprite_2d.visible=true
	label.text=str(quantity)
	label.visible=true

func empty():
	slot_item=null
	sprite_2d.texture=null
	sprite_2d.visible=false
	label.text="0"
	label.visible=false
