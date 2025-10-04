extends Control
class_name InvUiSlot
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label


var slot_item:Item
var item_quantity:int=0


func update(item:Item, quantity:int):
	if !slot_item:
		slot_item=item
		print(item.item_name)
		print(item.item_description)
		#sprite_2d.texture=item.item_texture
		#sprite_2d.visible=true
		label.text=str(quantity)
		label.visible=true
