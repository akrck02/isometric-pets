extends Node
class_name GraphicSettings

static func set_windowed_screen():
	SettingsManager.set_value("Display", "Mode", Display.WindowMode.Windowed)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

static func set_fullscreen():
	SettingsManager.set_value("Display", "Mode", Display.WindowMode.Fullscreen)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

static func toggle_fullscreen():
	var mode = SettingsManager.get_value("Display", "Mode")
	
	if(Display.WindowMode.Fullscreen == mode):
		set_windowed_screen()
		return
	
	set_fullscreen()
