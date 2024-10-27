extends Node2D

@onready var music = $Music

func _ready() -> void:
	music.play()
