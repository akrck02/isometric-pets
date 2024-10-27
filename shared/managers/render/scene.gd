extends Node

func _ready():
	SignalDatabase.scene_change_requested.connect(change_scene)

## Change scene with progress
func change_scene(scene_name : String):
	
	# Set up the path
	if !scene_name.begins_with("res://"):
		return
	
	# Get canvas layer
	var canvas = get_tree().get_root().get_node("/root/Canvas")
	var current_scenes = canvas.get_children()
	for past_scene in current_scenes:
		past_scene.queue_free()
		
	# Find the targeted scene
	var error = ResourceLoader.load_threaded_request(scene_name)
	
	# check for errors
	if error != OK:
		# handle your error 
		print("error occured while getting the scene " + scene_name)
		return

	var progress = [0]
	while progress[0] < 1:
		ResourceLoader.load_threaded_get_status(scene_name, progress)
	
	# adding scene to the root
	var scene : Node = ResourceLoader.load_threaded_get(scene_name).instantiate()
	canvas.add_child(scene)
