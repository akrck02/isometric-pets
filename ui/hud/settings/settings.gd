extends MarginContainer
@onready var exit_button : Button = $Scroll/Controls/ExitControlsMargin/ExitControls/ExitGameButton
@onready var general_volume_h_slider: HSlider = $Scroll/Controls/VolumeControls/GeneralVolumeHSlider

@onready var graphics_label : Label = $Scroll/Controls/GraphicsLabel
@onready var graphic_controls : VBoxContainer = $Scroll/Controls/GraphicControls

@onready var fullscreen_button : Button = $Scroll/Controls/GraphicControls/DisplayControls/FullScreen
@onready var windowed_button : Button = $Scroll/Controls/GraphicControls/DisplayControls/Windowed
@onready var tween : Tween

## Called when the node enters the scene tree for the first time.
func _ready():
	general_volume_h_slider.value = AudioSettings.get_general_volume()
	general_volume_h_slider.value_changed.connect(change_general_volume)
	
	if OSManager.is_desktop():
		fullscreen_button.pressed.connect(set_fullscreen)
		windowed_button.pressed.connect(set_windowed_screen)
		exit_button.pressed.connect(exit_game)
		custom_minimum_size = Vector2(0,600)
	else:
		graphics_label.hide()
		graphic_controls.hide()
		exit_button.hide()
		custom_minimum_size = Vector2(0,350)
		

## Exit game
func exit_game():
	get_tree().quit()


## Open menu
func open_menu() -> void:
	InputManager.context = Game.Context.Settings
	set_visible(true)
	
	tween = create_tween()
	var new_position = Vector2(position.x,get_viewport_rect().size.y - size.y)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	general_volume_h_slider.grab_focus()


## Close menu
func close_menu() -> void:
	InputManager.context = Game.Context.Camera
	
	tween = create_tween()
	var new_position = Vector2(position.x, get_viewport_rect().size.y)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	set_visible(false)


## Change general volume
func change_general_volume(value : float):
	SettingsManager.change_general_volume.emit(value)


## Set windowed screen
func set_windowed_screen():
	SettingsManager.set_windowed_screen.emit()


## Set fullscreen
func set_fullscreen():
	SettingsManager.set_fullscreen.emit()
