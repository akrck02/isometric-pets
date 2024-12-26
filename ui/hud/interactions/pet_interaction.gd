extends Control

@onready var food_button : Button = $VBoxContainer/ButtonsMarginContainer/HBoxContainer/Food
@onready var play_button : Button = $VBoxContainer/ButtonsMarginContainer/HBoxContainer/Play
@onready var pet_button : Button = $VBoxContainer/ButtonsMarginContainer/HBoxContainer/Pet

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
	play_button.pressed.connect(_play_with_pet)
	pet_button.pressed.connect(_pet_the_pet)

func _process(_delta: float) -> void:
	
	if InteractionManager.current_pet != null:	
		time_stat_label.text = "Time: %s" % InteractionManager.current_pet.stats.time
		hunger_stat_label.text = "Hunger: %s" % InteractionManager.current_pet.stats.hunger
		fun_stat_label.text = "Fun: %s" % InteractionManager.current_pet.stats.fun
		affection_stat_label.text = "Affection: %s" % InteractionManager.current_pet.stats.affection
		energy_stat_label.text = "Energy: %s" % InteractionManager.current_pet.stats.energy

## Give food to pet
func _give_food_to_pet() -> void:
	InteractionManager.current_pet.stats.hunger -= 1


## Give food to pet
func _play_with_pet() -> void:
	InteractionManager.current_pet.stats.fun += 1


## Give food to pet
func _pet_the_pet() -> void:
	InteractionManager.current_pet.stats.affection += 1
	
