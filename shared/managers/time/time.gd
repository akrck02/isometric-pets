extends Node

const tick_time : float = .75
var timer : Timer

signal night_started()
signal day_started()
signal tick_reached()

## Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = tick_time
	timer.autostart = true
	timer.timeout.connect(emitTickSignal)
	add_child(timer)

## Emit tick signal
func emitTickSignal():
	tick_reached.emit()

## Get real device time
func get_real_time() -> Dictionary:
	var time = Time.get_time_dict_from_system();
	# time.hour = 15
	return time

## Emits a signal with the given daytime
func emit_daytime():

	if is_daytime(): day_started.emit()
	else : night_started.emit()

## Get if it is night or day
func is_daytime() -> bool:
	var time = get_real_time()
	return time.hour > 6 && time.hour < 20 
