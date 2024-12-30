extends Control

@onready var name_label : Label = $Container/Scroll/Rows/Header/Rows/Name

@onready var time_stat_label : Label = $Container/Scroll/Rows/Header/Rows/Time
@onready var level_stat_label : Label = $Container/Scroll/Rows/Header/Rows/Level

@onready var hunger_stat_label : Label = $Container/Scroll/Rows/StatControlsContainer/Rows/HungerContainer/Label
@onready var hunger_stat_slider : HSlider = $Container/Scroll/Rows/StatControlsContainer/Rows/HungerContainer/HSlider

@onready var fun_stat_label : Label = $Container/Scroll/Rows/StatControlsContainer/Rows/FunContainer/Label
@onready var fun_stat_slider : HSlider = $Container/Scroll/Rows/StatControlsContainer/Rows/FunContainer/HSlider

@onready var affection_stat_label : Label = $Container/Scroll/Rows/StatControlsContainer/Rows/AffectionContainer/Label
@onready var affection_stat_slider : HSlider = $Container/Scroll/Rows/StatControlsContainer/Rows/AffectionContainer/HSlider

@onready var energy_stat_label : Label = $Container/Scroll/Rows/StatControlsContainer/Rows/EnergyContainer/Label
@onready var energy_stat_slider : HSlider = $Container/Scroll/Rows/StatControlsContainer/Rows/EnergyContainer/HSlider

@onready var exit_button : Button = $Container/Scroll/Rows/ButtonsContainer/ExitButton


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UIManager.interaction_started.connect(show)
	UIManager.interaction_ended.connect(hide)
	hunger_stat_slider.value_changed.connect(_set_hunger)
	fun_stat_slider.value_changed.connect(_set_fun)
	affection_stat_slider.value_changed.connect(_set_affection)
	energy_stat_slider.value_changed.connect(_set_energy)
	exit_button.pressed.connect(_exit)


## Process 
func _process(_delta: float) -> void:
	_refresh()


## Refresh UI
func _refresh() -> void:
	
	if null == InteractionManager.current_pet:
		return

	var nameformatData = {}
	nameformatData.name =  InteractionManager.current_pet.name.to_pascal_case()
	nameformatData.mood = CareEnums.mood_name_for(InteractionManager.current_pet.stats.mood)
	name_label.text = "{name} ({mood})".format(nameformatData)

	var raw_seconds = InteractionManager.current_pet.stats.time * TimeManager.tick_time
	var hours : int = raw_seconds / 60 / 60
	var minutes : int = raw_seconds / 60 - hours * 60
	
	var time = {
		"hh" : "%02d" % hours,
		"mm" :  "%02d" % minutes
	}
	
	time_stat_label.text = "Time {hh}:{mm}".format(time)
	level_stat_label.text = "Level %s" % InteractionManager.current_pet.stats.level
	
	hunger_stat_label.text = "Hunger %s" % InteractionManager.current_pet.stats.hunger
	hunger_stat_slider.value = InteractionManager.current_pet.stats.hunger
	
	fun_stat_label.text = "Fun %s" % InteractionManager.current_pet.stats.fun
	fun_stat_slider.value = InteractionManager.current_pet.stats.fun
	
	affection_stat_label.text = "Affection %s" % InteractionManager.current_pet.stats.affection
	affection_stat_slider.value = InteractionManager.current_pet.stats.affection
	
	energy_stat_label.text = "Energy %s" % InteractionManager.current_pet.stats.energy
	energy_stat_slider.value = InteractionManager.current_pet.stats.energy


## Set pet hunger
func _set_hunger(value : int) -> void:
	InteractionManager.current_pet.stats.hunger = value
	_refresh()


## Set pet fun
func _set_fun(value : int) -> void:

	InteractionManager.current_pet.stats.fun = value
	_refresh()


## Set pet affection
func _set_affection(value : int) -> void:
	
	InteractionManager.current_pet.stats.affection = value
	_refresh()


## Set pet energy 
func _set_energy(value : int) -> void:

	InteractionManager.current_pet.stats.energy = value
	_refresh()


## Exit the ui
func _exit() -> void:
	hide()
	InteractionManager.stop_interactions()
