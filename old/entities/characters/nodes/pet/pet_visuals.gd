extends Node2D
class_name PetVisuals

# Pet data
@export var pet_name : String = "tas"
@export var stats : CareStats = CareStats.new()
const OUTLINE_SHADER_MATERIAL : ShaderMaterial = preload("res://materials/general/outline_shader_material.tres")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite: Sprite2D = $Sprite

## Play animation based in mood
func play_mood_animation():
	match stats.mood:
		CareEnums.Mood.HAPPY : animation_player.play("happy")
		CareEnums.Mood.ANGRY : animation_player.play("angry")
		CareEnums.Mood.HUNGRY : animation_player.play("hungry")
		CareEnums.Mood.SAD : animation_player.play("sad")

	await animation_player.animation_finished


func _update_sprite() -> void:
	if not sprite:
		return
	
	sprite.texture = load(Paths.get_character("pet").get_sprite("%s.png" % pet_name))



## Prepare the visuals for nighttime
func _set_night() : 
	point_light_2d.show()


## Prepare the visuals for daytime
func _set_day() : 
	point_light_2d.hide()


## Toggle the sprite outline
func set_outline(value:bool):
	if value:
		sprite.material = OUTLINE_SHADER_MATERIAL
		return
		
	sprite.material = null
