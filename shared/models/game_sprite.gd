extends Node2D
class_name GameSprite

var spritesheet : Spritesheet = Spritesheet.new()
var coordinates : Vector2i = Vector2i.ZERO

# Fill game sprite from params
static func from(origin_spritesheet: Spritesheet, x : int, y : int ) -> GameSprite : 
	var sprite = new()
	sprite.spritesheet = origin_spritesheet
	sprite.coordinates.x = x
	sprite.coordinates.y = y 
	return sprite
