class_name CareStats
extends Node2D

const DEFAULT_TIME = 0
const DEFAULT_HUNGER = 0
const DEFAULT_FUN = 50
const DEFAULT_AFFECTION = 0
const DEFAULT_ENERGY = 100
const DEFAULT_MOOD_STATE = CareEnums.State.HAPPY

var time : int
var hunger : int
var fun : int
var affection : int
var energy : int
var mood : CareEnums.State

func _init():
	time = DEFAULT_TIME
	hunger = DEFAULT_HUNGER
	fun = DEFAULT_FUN
	affection = DEFAULT_AFFECTION
	energy = DEFAULT_ENERGY
	mood = DEFAULT_MOOD_STATE

func to_dictionary() -> Dictionary:
	return {
		"time": time,
		"hunger": hunger,
		"fun" : fun,
		"affection" : affection,
		"energy" : energy,
		"mood" : mood
	}

static func from_dictionary(data : Dictionary) -> CareStats:
	var stats = CareStats.new()
	
	stats.time = data.time
	stats.hunger = data.hunger
	stats.fun = data.fun
	stats.affection = data.affection
	stats.energy = data.energy
	stats.mood = data.mood
	
	return stats
