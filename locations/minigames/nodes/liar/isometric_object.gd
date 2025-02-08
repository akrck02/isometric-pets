## Class that contains methods to move in a isometric map
class_name IsometricObject
extends Node2D 

## Space between positions
const length = 40
@export var x: int
@export var y: int
var tilemaplayer: TileMapLayer



func _cartesian_to_isometric(x: int, y: int):
	var cartesian_pos = Vector2(x, y)
	var isometric_pos = Vector2()
	isometric_pos.x = (cartesian_pos.x - cartesian_pos.y) * length
	isometric_pos.y = ((cartesian_pos.x + cartesian_pos.y) / 2) * length
	x = isometric_pos.x
	y = isometric_pos.y
	return isometric_pos


## Changes the object global position
func move_global(x: int, y: int):
	#print(x,", ",y, tilemaplayer.map_to_local(Vector2(x,y)))
	self.global_position = _cartesian_to_isometric(x, y)


## Changes the object local position. The local position is the position relative to its parent.
func move_local(x: int, y: int):
	self.position = _cartesian_to_isometric(x, y)
