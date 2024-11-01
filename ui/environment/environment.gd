extends Control

@export var type : Environments.Type = Environments.Type.None

@onready var leafParticles : GPUParticles2D = $LeafParticles
@onready var rainParticles : GPUParticles2D = $RainParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UIManager.environment_changed.connect(_select_environment)
	_select_environment(type)

## Select an environment
func _select_environment(new_type : Environments.Type):
	_reset_environments()
	
	match new_type:
		Environments.Type.Leafs:
			leafParticles.emitting = true;
		Environments.Type.Rain:
			rainParticles.emitting = true
	
## Reset the current environment
func _reset_environments():
	rainParticles.emitting = false
	leafParticles.emitting = false
