extends Node
@onready var pet: Pet = $Pet

const PLAYERS = 4
const CARDS_PER_HAND = 5
@onready var control: Control = $Control
@onready var spin_box_y: SpinBox = $Control/HBoxContainer/SpinBoxY
@onready var spin_box_x: SpinBox = $Control/HBoxContainer/SpinBoxX
@onready var button: Button = $Control/HBoxContainer/Button
var deck: Deck
@onready var player_0: Player = $Player0
@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var player_3: Player = $Player3
@onready var button_2: Button = $Control/HBoxContainer/Button2

var turn:int=0;
var game_finished:bool=false
var timer=Timer.new()
var timer_ended:int=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	
	# Generate Deck
	deck = Deck.new()
	# Create hands
	var hands = deck.generate_hands()
	var hands_up = hands[0]
	var hands_down = hands[1]
	var hands_left = hands[2]
	var hands_right = hands[3]
	var x = 0
	var y = 3
	
	
	# Set id
	
	# Set facing
	
	# Set name
	
	# Set hand location

	player_0.id = 0
	player_0.facing = Constants.FACING.DOWN
	player_0.set_hand(hands_down)
	player_0.set_player_name("tas")
	player_0._hand.move_local(-2, 3)
	player_0._hand.set_reveal(true)
	player_0._hand.set_user(0)
	

	player_1.id = 1
	player_1.facing = Constants.FACING.UP
	player_1.set_hand(hands_up)
	player_1.set_player_name("foxy")
	player_1._hand.move_local(-2, -3)
	player_1._hand.set_user(1)

	player_2.id = 2
	player_2.facing = Constants.FACING.RIGHT
	player_2.set_hand(hands_right)
	player_2.set_player_name("teko")
	player_2._hand.move_local(3, -2)
	player_2._hand.set_user(2)

	player_3.id = 3
	player_3.facing = Constants.FACING.LEFT
	player_3.set_hand(hands_left)
	player_3.set_player_name("soriel")
	player_3._hand.move_local(-3, -2)
	player_3._hand.set_user(3)

	button.pressed.connect(move.bind(player_1._hand))
	button_2.pressed.connect(add_card)
	for player in [player_0,player_1]:
		print(player)
		
		
	SignalDatabase.tick_reached.connect(tick_update)
	
	timer.wait_time=5
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func add_card():
	var player = player_2
	var card = Card.new()
	card.number = 3
	card.color = "red"
	card.set_facing(Constants.FACING.UP)
	player._hand.add_card(card)


func move(object: IsometricObject):
	object.move_global(spin_box_x.value, spin_box_y.value)

func tick_update() -> void:
	if timer_ended:
		
		print("Turno de {0}".format([turn]))
		
		if turn==0:
			print("Cards selectable")
			player_0._hand.set_selectable(true)
		else:
			player_0._hand.set_selectable(false)
			# Unselect selected cards
			player_0._hand.unselect()
		
		# Set turn between 0 and 3
		turn = (turn + 1) % 4
		self.timer_ended=false
		self.timer.start()
	
func _on_timer_timeout():
	self.timer_ended=true
	