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

func save() -> Dictionary:
	return {
		"time": time,
		"hunger": hunger,
		"fun" : fun,
		"affection" : affection,
		"energy" : energy,
		"mood" : mood
	}
