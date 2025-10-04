extends Control
@onready var sprite_2d: Sprite2D = $PanelContainer/Sprite2D


var item:Item

func update(item:Item):
	if !item:
		sprite_2d.visible=false
	else:
		sprite_2d.visible=true
		sprite_2d.texture=item.item_texture
