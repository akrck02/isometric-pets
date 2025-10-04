extends Node

var _plugin_name = "GodotNFC"
var _android_plugin

signal pet_change_requested(data : String)

func _ready():
	print("--------- LOADING TEST ---------")
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
		_android_plugin.connect("nfc_enabled", _on_nfc_enabled)
		_android_plugin.connect("nfc_scanned", _on_nfc_tag_readed)
		_android_plugin.enableNfc()
		_android_plugin.setNfcCallback()
	else:
		printerr("Couldn't find plugin " + _plugin_name)
		

func _on_nfc_enabled(status : String) -> void:
	print("NFC Status:%s\n" % status)


func _on_nfc_tag_readed(data : String) -> void:
	var json_string : String = "{%s" % data.get_slice("{",1)
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		pet_change_requested.emit(data_received["uuid"])
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
	
