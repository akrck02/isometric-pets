class_name Spritesheet

var path : String = "res://icon.svg"
var size : Vector2i = Vector2.ONE

# Fill SpriteSheet form params
static func from(sheet_path : String, width : int, height : int) -> Spritesheet:
	var sprite_sheet = new()
	sprite_sheet.path = sheet_path
	sprite_sheet.size.x = width
	sprite_sheet.size.y = height
	return sprite_sheet
