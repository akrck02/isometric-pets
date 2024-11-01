extends Camera2D
class_name SmartCamera

# Camera focus 
@export var focus_node : Node2D;
var focusing : bool = false

# Zoom params
@export var default_zoom : Vector2 = Vector2(3,3);
@export var min_zoom : float = 1;
@export var max_zoom : float = 6;
var start_zoom

# Speed variables
@export var zoom_speed : float = 0.1;
@export var pan_speed : float = 0.1;
@export var rotation_speed : float = 0.1;

# Flags
@export var can_move : bool = true;
@export var can_zoom : bool = true;
@export var can_pan : bool = true;
@export var can_rotate : bool = false;

# Movement animation
@onready var zoom_tween : Tween
@onready var offset_tween : Tween
@export var movement_speed = 1.00/1.5;
var start_distance = 0

var delta_time = 1


## Called when the node enters the scene tree for the first time.
func _ready():
	
	InputManager.prepare_zoom_requested.connect(prepare_zoom_camera)
	InputManager.zoom_requested.connect(zoom_camera)
	InputManager.find_requested.connect(return_to_default_camera_position)
	InputManager.movement_requested.connect(pan_camera)
	UIManager.camera_movement_updated.connect(update_can_move)

	# if it is being played on desktop, show more 
	if OSManager.is_desktop():
		default_zoom *= 0.65

	zoom = default_zoom
	if focus_node != null: 
		focusing = true


## Process operations
func _process(delta):
	
	delta_time = delta
	
	if not is_current_context() or not can_move:
		return;
	
	if camera_is_not_focused(): 
		var message = ""
		match InputManager.current_input:
			Controls.Type.Touch: 			message = "Tap with 3 fingers to center the camera";
			Controls.Type.KeyboardAndMouse: message = "Press E to center the camera"
			Controls.Type.Gamepad: 			message = "Press R1 to center the camera"
		
		UIManager.notification_shown.emit("[center] %s" % message) 
	else: 
		if focus_node != null:
			position = focus_node.position - offset
		
		UIManager.notification_hidden.emit() 


## Get if the camera is outside the max offset
func camera_is_not_focused() -> bool:
	return zoom != default_zoom or offset.x < -80 or offset.x > 80 or offset.y < -80 or offset.y > 80


## Prepare zoom camera
func prepare_zoom_camera(_data : InputData):
	start_zoom = zoom


## Zoom camera
func zoom_camera(data : InputData):
	if not is_current_context() or not can_zoom:
		return;
	
	match data.origin: 
		Controls.Type.Touch: 
			zoom = limit_zoom(start_zoom / data.touch_data.get_drag_distance_factor())
		Controls.Type.Gamepad:
			var new_zoom = limit_zoom(zoom * data.gamepad_data.zoom_percentage)
			zoom_tween = create_tween()
			zoom_tween.tween_property(self, NodeProperties.Zoom, new_zoom, movement_speed / 2).set_trans(Tween.TRANS_SINE)
			await zoom_tween.finished
			zoom_tween.kill()
		Controls.Type.KeyboardAndMouse:
			zoom = limit_zoom(zoom * data.keyboard_and_mouse_data.zoom_percentage)


## Limit max and min zoom
func limit_zoom(new_zoom : Vector2) -> Vector2:
	if new_zoom.x <= min_zoom: new_zoom.x = min_zoom
	if new_zoom.x >= max_zoom: new_zoom.x = max_zoom
	if new_zoom.y <= min_zoom: new_zoom.y = min_zoom
	if new_zoom.y >= max_zoom: new_zoom.y = max_zoom
	return new_zoom
	

## Return to default camera position 
func return_to_default_camera_position(_data : InputData) -> void:
	
	if not is_current_context():
		return
	
	offset_tween = create_tween()
	offset_tween.tween_property(self, NodeProperties.Offset, Vector2.ZERO, movement_speed).set_trans(Tween.TRANS_SINE)
	await offset_tween.finished
	offset_tween.kill()
	
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, NodeProperties.Zoom, default_zoom, movement_speed).set_trans(Tween.TRANS_SINE)
	await zoom_tween.finished
	zoom_tween.kill()


## Pan camera
func pan_camera(data : InputData):
	if not is_current_context() or not can_pan:
		return
	
	match data.origin: 
		Controls.Type.Touch: 
			offset -= data.touch_data.relative * pan_speed / zoom.x;
		Controls.Type.Gamepad:
			offset += data.gamepad_data.direction * 30 * pan_speed * delta_time / zoom.x;


## Update the can move property
func update_can_move(value : bool):
	can_move = value


## Is current context
func is_current_context() -> bool:
	return InputManager.context == Game.Context.Camera;
