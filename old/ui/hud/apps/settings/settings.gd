extends App

@onready var exit_button : Button = $Rows/ExitControlsMargin/ExitControls/ExitGameButton
@onready var general_volume_label : Label =  $Rows/VolumeLabel
@onready var general_volume_h_slider: HSlider = $Rows/VolumeControls/GeneralVolumeHSlider

@onready var graphics_label : Label = $Rows/GraphicsLabel
@onready var graphic_controls : VBoxContainer = $Rows/GraphicControls

@onready var speed_normal_button : Button = $Rows/TextSpeedControls/TextSpeedControls/Normal
@onready var speed_fast_button : Button = $Rows/TextSpeedControls/TextSpeedControls/Fast

@onready var fullscreen_button : Button = $Rows/GraphicControls/DisplayControls/FullScreen
@onready var windowed_button : Button = $Rows/GraphicControls/DisplayControls/Windowed

const NORMAL_TEXT_SPEED : int = 50
const FAST_TEXT_SPEED : int = 100

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	general_volume_label.text = "Volume - %s%%" % (AudioSettings.get_general_volume() * 100)
	general_volume_h_slider.value = AudioSettings.get_general_volume()
	general_volume_h_slider.value_changed.connect(change_general_volume)
	
	speed_normal_button.pressed.connect(_set_normal_text_speed)
	speed_fast_button.pressed.connect(_set_fast_text_speed)
	
	if OSManager.is_desktop():
		fullscreen_button.pressed.connect(set_fullscreen)
		windowed_button.pressed.connect(set_windowed_screen)
		exit_button.pressed.connect(exit_game)
	else:
		graphics_label.hide()
		graphic_controls.hide()
		exit_button.hide()

## Exit game
func exit_game() -> void:
	get_tree().quit()


## Change general volume
func change_general_volume(value : float) -> void:
	general_volume_label.text = "Volume - %s%%" % (value * 100)
	SettingsManager.change_general_volume.emit(value)


## Set windowed screen
func set_windowed_screen() -> void:
	SettingsManager.set_windowed_screen.emit()


## Set fullscreen
func set_fullscreen() -> void:
	SettingsManager.set_fullscreen.emit()


## Set normal text speed
func _set_normal_text_speed() -> void:
	SettingsManager.set_text_speed.emit(NORMAL_TEXT_SPEED)
	_decorate_text_speed_buttons()


## Set fast text speed
func _set_fast_text_speed() -> void:
	SettingsManager.set_text_speed.emit(FAST_TEXT_SPEED)
	_decorate_text_speed_buttons()


## Decorate text speed buttons
func _decorate_text_speed_buttons() -> void:
	var text_speed = SettingsManager.get_text_speed()
	if text_speed == NORMAL_TEXT_SPEED:
		speed_normal_button.disabled = true
		speed_fast_button.disabled = false
	elif text_speed == FAST_TEXT_SPEED:
		speed_fast_button.disabled = true
		speed_normal_button.disabled = false
