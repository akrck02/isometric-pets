extends Control
class_name InvUiSlot

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D


var slot_item:Item
var item_quantity:int=0


func _ready() -> void:
	self.pressed.connect(_on_click)

func _on_click():
	var actions:Inventory = self.get_parent().get_parent().get_parent()
	actions.open_actions(slot_item.item_name, slot_item.item_texture, slot_item.item_description)
	print(actions)

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
