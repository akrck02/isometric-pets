extends Node

# Constants
const NUM_PLAYERS = 4
const TURN_TIME = 120

# Preloads
const Player = preload("res://locations/minigames/nodes/liar/nodes/player.gd")
const card_scene = preload("res://locations/minigames/nodes/liar/nodes/card.tscn");

# UI elements
@onready var play_button: Button = $UI/Margin/HBoxContainer/PlayButton
@onready var liar_button: Button = $UI/Margin/HBoxContainer/LiarButton
@onready var spin_box: SpinBox = $UI/Margin/HBoxContainer/SpinBox
@onready var next_turn_button: Button = $UI/Margin/HBoxContainer/NextTurnButton

# Welcome Screen
@onready var welcome: CanvasLayer = $Welcome
@onready var start_button: Button = $Welcome/MarginContainer/HFlowContainer/StartButton
@onready var how_to_play_button: Button = $Welcome/MarginContainer/HFlowContainer/HowToPlayButton
@onready var exit_button: Button = $Welcome/MarginContainer/HFlowContainer/ExitButton

# Game logic
@onready var stack: Stack = $Stack
@onready var timer: TurnTimer = $Timer
@onready var player_0: Player = $Player0
@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var player_3: Player = $Player3

var turn: int = -1
var game_finished: bool = false
var players: Array = [player_0, player_1, player_2, player_3]
var previous_player: Player
var actual_player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	welcome.show()
	
	# Connect buttons
	play_button.pressed.connect(on_play_button)
	liar_button.pressed.connect(on_liar_button)
	start_button.pressed.connect(on_start_button)
	how_to_play_button.pressed.connect(on_how_to_play_button)
	exit_button.pressed.connect(on_exit_button)
	
	# Create cards
	var cards = []
	for color_name in Constants.COLORS.keys():
		var color = Constants.COLORS[color_name]
		for num in range(10):
			var card_instance = card_scene.instantiate()
			card_instance.color = color
			card_instance.number = num
			card_instance.update_sprite()
			cards.append(card_instance)
	cards.shuffle()
	
	players = [player_0, player_1, player_2, player_3]
	
	# Set players positions depending on screen size
	var screen_size = DisplayServer.screen_get_size()
	player_0.global_position = Vector2(0, screen_size.y / 2)
	player_1.global_position = Vector2(-screen_size.x / 2, 0)
	player_2.global_position = Vector2(0, -screen_size.y / 2)
	player_3.global_position = Vector2(screen_size.x / 2, 0)
	
	# Deal the cards
	player_0.hand.add_cards(cards.slice(0, 9))
	player_0.hand.set_show_cards(true)
	player_1.hand.add_cards(cards.slice(10, 19))
	player_2.hand.add_cards(cards.slice(20, 29))
	player_3.hand.add_cards(cards.slice(30, 39))

func on_start_button():
	welcome.hide()
	start_game()
	
func on_how_to_play_button():
	# TODO
	pass
	
func on_exit_button():
	SceneManager.scene_change_requested.emit(Paths.get_world().get_scene())

func on_play_button():
	print("On play button")
	var selected_cards = player_0.hand.pop_selected_cards()
	player_0.hand.unselect()
	stack.add_cards(selected_cards)
	player_0.latest_statement = spin_box.value
	timer.stop()

func on_liar_button():
	liar()
	timer.stop()
	
func start_game():
	play_button.disabled = true
	liar_button.disabled = true
	TimeManager.tick_reached.connect(tick_update)
	await wait_for_turn_to_end()
	
## Executed when player uses Liar!
func liar() -> void:
	print("Player ", actual_player, " chose Liar")
	var latest_statement = previous_player.latest_statement
	print("Latest Statement: ", latest_statement)

	if stack.latest_statement_true(latest_statement):
		print("It was true statement")
		actual_player.hand.add_cards(stack.pop_cards(), actual_player.id == 0)

	else:
		print("It was false statement")
		previous_player.hand.add_cards(stack.pop_cards(), previous_player.id == 0)
		turn = (turn - 1)%NUM_PLAYERS
		
	timer.stop()

## Executed when player uses Play
func play() -> void:
	print("Player ", actual_player, " chose Play")
	var lie = randi_range(0, 9)
	
	if lie < 3:
		print("Player ", actual_player, " chose Lie")
		var test = actual_player.lie()
		stack.add_cards(test)
		
	else:
		print("Player ", actual_player, " chose Truth")
		var test = actual_player.truth()
		stack.add_cards(test)
		
	timer.stop()
	
func _turn_started():
	turn = (turn + 1) % NUM_PLAYERS
	print("Turn " + str(turn) + " started")
	var previous_player_index = (turn - 1) % 4
	previous_player = players[previous_player_index]
	actual_player = players[turn]
	
	if actual_player.id == 0:
		player_0.hand.set_selectable(true)
		play_button.disabled = false
		liar_button.disabled = false
	else:
		player_0.hand.set_selectable(false)
		player_0.hand.unselect()
		play_button.disabled = true
		liar_button.disabled = true
	timer.start(actual_player, 9)
	wait_for_turn_to_end()
	
# Function to wait for the turn to end
func wait_for_turn_to_end() -> void:
	await SignalDatabase.turn_finished
	
	if actual_player.id != 0:
		# Liar or play
		var play_or_liar = randf_range(0, 9)
		if play_or_liar < 3:
			liar()
		else:
			play()
	print("Turn " + str(turn) + " finished" + "\n")

func tick_update() -> void:
	if timer.turn_ended:
		timer.turn_ended = false
		print("tick")
		_turn_started()
	return
	
