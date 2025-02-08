extends Node
@onready var pet: Pet = $Pet

const NUM_PLAYERS = 4
const CARDS_PER_HAND = 5
const TURN_TIME = 120

@onready var control: Control = $Control
@onready var spin_box_y: SpinBox = $Control/HBoxContainer/SpinBoxY
@onready var spin_box_x: SpinBox = $Control/HBoxContainer/SpinBoxX
@onready var button: Button = $Control/HBoxContainer/Button
@onready var player_0: Player = $Player0
@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var player_3: Player = $Player3
@onready var button_2: Button = $Control/HBoxContainer/Button2
@onready var play_button: Button = $Control2/HBoxContainer/PlayButton
@onready var liar_button: Button = $Control2/HBoxContainer/LiarButton
@onready var spin_box: SpinBox = $Control2/HBoxContainer/SpinBox
@onready var stack: Stack = $Stack
@onready var timer: TurnTimer = $Timer


var turn: int = 0
var game_finished: bool = false
var players: Array
var previous_player:Player 
var actual_player:Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = [player_0, player_1, player_2, player_3]

	# Create hands
	var hands = stack.generate_hands()
	var hands_up = hands[0]
	var hands_down = hands[1]
	var hands_left = hands[2]
	var hands_right = hands[3]

	player_0.id = 0
	player_0.facing = Constants.FACING.DOWN
	player_0.set_hand(hands_down)
	player_0.set_reveal_cards(true)
	player_0.set_player_name("tas")
	player_0._hand.move_local(-2, 3)

	player_1.id = 1
	player_1.facing = Constants.FACING.RIGHT
	player_1.set_hand(hands_right)
	player_1.set_player_name("foxy")
	player_1._hand.move_local(3, -2)

	player_2.id = 2
	player_2.facing = Constants.FACING.UP
	player_2.set_hand(hands_up)
	player_2.set_player_name("teko")
	player_2._hand.move_local(-2, -3)

	player_3.id = 3
	player_3.facing = Constants.FACING.LEFT
	player_3.set_hand(hands_left)
	player_3.set_player_name("soriel")
	player_3._hand.move_local(-3, -2)


	play_button.disabled = true
	liar_button.disabled = true

	SignalDatabase.tick_reached.connect(tick_update)
	play_button.pressed.connect(on_play_button)
	liar_button.pressed.connect(on_liar_button)

func on_play_button():
	var selected_cards = player_0.pop_selected_cards()
	print(selected_cards)
	stack.add_cards(selected_cards)
	player_0.latest_statement = spin_box.value
	timer.stop()


func on_liar_button():
	liar()
	timer.stop()

## Executed when player uses Liar!
func liar()->void:
	print("Player ",actual_player, " chose Liar")
	var latest_statement = previous_player.latest_statement
	print("Latest Statement: ",latest_statement)

	if stack.latest_statement_true(latest_statement):
		print("Era verdad")
		actual_player.add_cards(stack.pop_cards())

	else:
		print("Era mentira")
		previous_player.add_cards(stack.pop_cards())
		
		# If the player discovers a lie, starts the next round
		turn= (turn-1)%NUM_PLAYERS



## Executed when player uses Play
func play()->void:
	print("Player ",actual_player, " chose Play")
				
	var lie = randi_range(0,9)
	
	if lie<3:
		print("Player ",actual_player, " chose Lie")
		
		var test=actual_player.lie()
		stack.add_cards(test)
		
	else:
		print("Player ",actual_player, " chose Truth")
		var test=actual_player.truth()
		stack.add_cards(test)
		
	timer.stop()
	

func tick_update() -> void:
	if not timer.turn_ended:
		return
	
	print("Turno de {0}".format([players[turn]]))
	var previous_player_index = (turn - 1) % 4
	previous_player = players[previous_player_index]
	actual_player = players[turn]
	
	
	if actual_player.id == 0:
		player_0._hand.set_selectable(true)
		play_button.disabled = false
		liar_button.disabled = false
		timer.start(player_0,60)
	else:
		player_0._hand.set_selectable(false)
		# Unselect selected cards
		player_0._hand.unselect()

		play_button.disabled = true
		liar_button.disabled = true
		
		# Liar or play
		var play_or_liar = randf_range(0,9)

		if play_or_liar < 3: 
			liar()
		else:  
			play()
				
		timer.stop()

		timer.start(players[(turn + 1) %NUM_PLAYERS],5)
	print("----\n")
	# Set turn between 0 and 3
	turn = (turn + 1) %NUM_PLAYERS
