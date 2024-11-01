class_name PetStats
extends Node2D

const DEFAULT_TIME = 0
const DEFAULT_HUNGER = 0
const DEFAULT_FUN = 50
const DEFAULT_AFFECTION = 0
const DEFAULT_ENERGY = 100
const DEFAULT_EVOLUTION_STATE = CareEnums.State.HAPPY

var time : int
var hunger : int
var fun : int
var affection : int
var energy : int
var evolution_state : CareEnums.State

func _init():
	time = DEFAULT_TIME
	hunger = DEFAULT_HUNGER
	fun = DEFAULT_FUN
	affection = DEFAULT_AFFECTION
	energy = DEFAULT_ENERGY
	evolution_state = DEFAULT_EVOLUTION_STATE
