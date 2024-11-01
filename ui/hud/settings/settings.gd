extends Control
@onready var exit_button : Button = $Scroll/Margin/Controls/ExitControlsMargin/ExitControls/ExitGameButton
@onready var close_menu_button : Button = $Scroll/Margin/Controls/ExitControlsMargin/ExitControls/CloseMenuButton
@onready var general_volume_h_slider: HSlider = $Scroll/Margin/Controls/VolumeControls/GeneralVolumeHSlider

@onready var graphics_label : Label = $Scroll/Margin/Controls/GraphicsLabel
@onready var graphic_controls : VBoxContainer = $Scroll/Margin/Controls/GraphicControls

@onready var fullscreen_button : Button = $Scroll/Margin/Controls/GraphicControls/DisplayControls/FullScreen
@onready var windowed_button : Button = $Scroll/Margin/Controls/GraphicControls/DisplayControls/Windowed

@onready var low_cpu_mode_button : Button = $Scroll/Margin/Controls/PerformanceControls/LowCpuMode


## Called when the node enters the scene tree for the first time.
func _ready():
	general_volume_h_slider.value = AudioSettings.get_general_volume()
	close_menu_button.pressed.connect(close_menu)
	general_volume_h_slider.value_changed.connect(change_general_volume)
	low_cpu_mode_button.pressed.connect(toggle_low_cpu_mode)
	
	if OSManager.is_desktop():
		fullscreen_button.pressed.connect(set_fullscreen)
		windowed_button.pressed.connect(set_windowed_screen)
		exit_button.pressed.connect(exit_game)
	else:
		graphics_label.hide()
		graphic_controls.hide()
		exit_button.hide()
		

## toggle_low_cpu_mode
func toggle_low_cpu_mode():
	OS.low_processor_usage_mode = not OS.low_processor_usage_mode  


## Exit game
func exit_game():
	get_tree().quit()


## Close menu
func close_menu() -> void:
	InputManager.context = Game.Context.Camera
	set_visible(false)

## Open menu
func open_menu() -> void:
	InputManager.context = Game.Context.Settings
	set_visible(true)
	general_volume_h_slider.grab_focus()


## Change general volume
func change_general_volume(value : float):
	SettingsManager.change_general_volume.emit(value)


## Set windowed screen
func set_windowed_screen():
	SettingsManager.set_windowed_screen.emit()


## Set fullscreen
func set_fullscreen():
	SettingsManager.set_fullscreen.emit()
