extends Sprite2D
class_name ChatBubble

# Icons
@onready var icon : Sprite2D = $Icon
@export var icon_sprite : GameSprite = GameSprites.onigiri

# Animations
@onready var animation_player = $AnimationPlayer

# Actions on node is ready
func _ready():
	animation_player.play("idle")
	update_graphics()

# Actions per game update
func _process(_delta: float):
	update_graphics()

# Update graphics 
func update_graphics():
	icon.texture = load(icon_sprite.spritesheet.path)
	icon.frame_coords = icon_sprite.coordinates
	icon.hframes = icon_sprite.spritesheet.size.x
	icon.vframes = icon_sprite.spritesheet.size.y
