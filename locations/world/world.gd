extends Node2D

@onready var music = $Music/Music

func _ready() -> void:
	music.play()
