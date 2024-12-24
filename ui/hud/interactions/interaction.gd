extends Control

@onready var food_button : Button = $VBoxContainer/ButtonsMarginContainer/Button

@onready var time_stat_label : Label = $VBoxContainer/StatsMarginContainer/StatsContainer/Time
@onready var hunger_stat_label : Label = $VBoxContainer/StatsMarginContainer/StatsContainer/Hunger
@onready var fun_stat_label : Label = $VBoxContainer/StatsMarginContainer/StatsContainer/Fun
@onready var affection_stat_label : Label = $VBoxContainer/StatsMarginContainer/StatsContainer/Affection
@onready var energy_stat_label : Label = $VBoxContainer/StatsMarginContainer/StatsContainer/Energy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UIManager.interaction_started.connect(show)
	UIManager.interaction_ended.connect(hide)
	food_button.pressed.connect(_give_food_to_pet)

func _process(delta: float) -> void:
	
	if InteractionManager.current_pet != null:	
		time_stat_label.text = "Time: %s" % InteractionManager.current_pet.stats.time
		hunger_stat_label.text = "Hunger: %s" % InteractionManager.current_pet.stats.hunger
		fun_stat_label.text = "Fun: %s" % InteractionManager.current_pet.stats.fun
		affection_stat_label.text = "Affection: %s" % InteractionManager.current_pet.stats.affection
		energy_stat_label.text = "Energy: %s" % InteractionManager.current_pet.stats.energy

## Give food to pet
func _give_food_to_pet() -> void:
	InteractionManager.give_food_to_current_pet(1)
	
