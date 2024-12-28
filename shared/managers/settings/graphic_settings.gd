extends Node
class_name GraphicSettings

static var DISPLAY_REGION : String = "Display"
static var MODE_KEY : String = "Mode"

## Apply current configuration
static func apply_current_configuration() -> void:
	match get_display_mode():
		Display.WindowMode.Windowed: set_windowed_screen()
		Display.WindowMode.Fullscreen: set_fullscreen()


## Get the current display mode
static func get_display_mode() -> Display.WindowMode:
	return SettingsManager.get_value(DISPLAY_REGION, MODE_KEY)


## Set windowed screen
static func set_windowed_screen() -> void:
	SettingsManager.set_value(DISPLAY_REGION, MODE_KEY, Display.WindowMode.Windowed)
	## DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if OSManager.is_desktop():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	


## Set fullscreen
static func set_fullscreen() -> void:
	SettingsManager.set_value(DISPLAY_REGION, MODE_KEY, Display.WindowMode.Fullscreen)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


## Toggle fullscreen
static func toggle_fullscreen() -> void:
	var mode = get_display_mode()
	
	if(Display.WindowMode.Fullscreen == mode):
		set_windowed_screen()
		return
	
	set_fullscreen()
