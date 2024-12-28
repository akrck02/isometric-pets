extends MarginContainer

@onready var open_button : Button = $MarginContainer/OpenButton
@onready var tween : Tween

var animation_playing : bool = false
var expanded : bool = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(position.x, get_viewport_rect().size.y - 70)
	open_button.pressed.connect(toggle)
	InputManager.find_requested.connect(_toggle_by_input_data)
	
	if OSManager.is_desktop(): 
		size.x = 400
		
	else: pass

func _toggle_by_input_data(_data):
	toggle()


## Toggle apps 
func toggle():
	
	if expanded:
		close_menu()
		return
	
	open_menu()



## Open menu
func open_menu() -> void:
	
	if animation_playing: return
	
	animation_playing = true
	InputManager.context = Game.Context.Settings
	
	tween = create_tween()
	var new_position = Vector2(position.x,get_viewport_rect().size.y - size.y)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	animation_playing = false
	expanded = true


## Close menu
func close_menu() -> void:
	
	if animation_playing: return
	
	animation_playing = true
	InputManager.context = Game.Context.Camera
	
	tween = create_tween()
	var new_position = Vector2(position.x, get_viewport_rect().size.y - 70)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	animation_playing = false
	expanded = false
