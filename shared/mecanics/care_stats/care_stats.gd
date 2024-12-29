class_name CareStats
extends Node2D

const DEFAULT_LEVEL : int = 0
const DEFAULT_TIME : int = 0
const DEFAULT_HUNGER : int = 0
const DEFAULT_FUN : int = 50
const DEFAULT_AFFECTION : int = 0
const DEFAULT_ENERGY : int = 100
const DEFAULT_MOOD_STATE : CareEnums.Mood = CareEnums.Mood.HAPPY

const MAX_LEVEL : int = 100
const MAX_HUNGER : int = 100
const MAX_FUN : int = 100
const MAX_AFFECTION : int = 100
const MAX_ENERGY : int = 100

var time : int = DEFAULT_TIME: 
	set(value): time = clamp(value, 0, GDScriptValues.MAX_INTEGER_VALUE)
var level : int = DEFAULT_LEVEL: 
	set(value): level = clamp(value, 0, MAX_LEVEL)
var hunger : int = DEFAULT_HUNGER: 
	set(value): hunger = clamp(value, 0, MAX_HUNGER)
var fun : int = DEFAULT_FUN: 
	set(value): fun = clamp(value, 0, MAX_FUN)
var affection : int = DEFAULT_AFFECTION: 
	set(value): affection = clamp(value, 0, MAX_AFFECTION)
var energy : int = DEFAULT_ENERGY: 
	set(value): energy = clamp(value, 0, MAX_ENERGY)
var mood : CareEnums.Mood = DEFAULT_MOOD_STATE : get = _calculate_mood


## Constructor with default value
func _init():
	time = DEFAULT_TIME
	level = DEFAULT_LEVEL
	hunger = DEFAULT_HUNGER
	fun = DEFAULT_FUN
	affection = DEFAULT_AFFECTION
	energy = DEFAULT_ENERGY
	mood = DEFAULT_MOOD_STATE


## Get dictionary from care stats
func to_dictionary() -> Dictionary:
	return {
		"level" : level,
		"time": time,
		"hunger": hunger,
		"fun" : fun,
		"affection" : affection,
		"energy" : energy,
		"mood" : mood
	}


## Get care stats from dictionary
static func from_dictionary(data : Dictionary) -> CareStats:
	var stats = CareStats.new()
	
	stats.level
	stats.time = data.time
	stats.hunger = data.hunger
	stats.fun = data.fun
	stats.affection = data.affection
	stats.energy = data.energy
	stats.mood = data.mood
	
	return stats


## Calculate mood based on stats
func _calculate_mood() -> CareEnums.Mood: 
	
	if hunger >= 80: 
		return CareEnums.Mood.HUNGRY
	
	if fun <= 20: 
		if affection <= 20: 
			return CareEnums.Mood.ANGRY
		
		return CareEnums.Mood.SAD
	
	return CareEnums.Mood.HAPPY
