extends Control
@onready var exit_button : Button = $Scroll/Margin/Controls/ExitControlsMargin/ExitControls/ExitGameButton
@onready var close_menu_button : Button = $Scroll/Margin/Controls/ExitControlsMargin/ExitControls/CloseMenuButton
@onready var general_volume_h_slider: HSlider = $Scroll/Margin/Controls/VolumeControls/GeneralVolumeHSlider

@onready var fullscreen_button : Button = $Scroll/Margin/Controls/GraphicControls/DisplayControls/FullScreen
@onready var windowed_button : Button = $Scroll/Margin/Controls/GraphicControls/DisplayControls/Windowed

## Called when the node enters the scene tree for the first time.
func _ready():
	general_volume_h_slider.value = AudioSettings.get_general_volume()
	exit_button.pressed.connect(exit_game)
	close_menu_button.pressed.connect(close_menu)
	general_volume_h_slider.value_changed.connect(change_general_volume)
	fullscreen_button.pressed.connect(set_fullscreen)
	windowed_button.pressed.connect(set_windowed_screen)

## Exit game
func exit_game():
	get_tree().quit()


## Close menu
func close_menu() -> void:
	InputManager.context = Game.Context.Camera
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
