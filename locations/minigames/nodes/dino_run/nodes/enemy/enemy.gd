extends CharacterBody2D
class_name DinoRunEnemy

@export var global_speed : float = 1
@onready var sprite : Sprite2D = $Sprite
var speed : float = 145.0
var type : int = 0

func _ready() -> void:
	match type:
		1: sprite.texture = preload("res://entities/animals/nodes/turtle/sprites/gomi.png")
		2: sprite.texture = preload("res://entities/animals/nodes/cat/sprites/cat.png")

func _physics_process(_delta: float) -> void:
	var direction = Vector2(-1,-.5)
	velocity = direction * (speed * global_speed)
	move_and_slide()
