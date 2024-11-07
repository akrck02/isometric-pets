extends Node

@onready var operating_system : String = OperatingSystems.UNKNOWN

## Logic to be executed when manager starts
func _ready() -> void:
	
	match OS.get_name():
		OperatingSystems.LINUX:		operating_system = OperatingSystems.LINUX
		OperatingSystems.WINDOWS:	operating_system = OperatingSystems.WINDOWS
		OperatingSystems.ANDROID:	operating_system = OperatingSystems.ANDROID


## Get if current OS is Linux
func is_linux() -> bool:
	return operating_system == OperatingSystems.LINUX

## Get if current OS is Android
func is_android() -> bool:
	return operating_system == OperatingSystems.ANDROID

## Get if current OS is Windows
func is_windows() -> bool:
	return operating_system == OperatingSystems.WINDOWS


## Get if current OS is a desktop OS
func is_desktop() -> bool:
	return is_linux() or is_windows()
