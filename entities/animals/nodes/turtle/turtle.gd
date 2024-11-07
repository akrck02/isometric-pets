extends CharacterBody2D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("idle")
