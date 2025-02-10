extends Node2D
class_name Player

## Players of the [Liar] minigame
@export var id: int
@export var player_name: String = "teko"
@export var hide_cards: bool
@export var color: Color

@onready var hand: Hand = $Hand
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var circle: Panel = $Circle

## List of [Card]s
var facing: Constants.FACING
var latest_statement: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set if cards in hand are hidden
	hand.reveal = hide_cards
	
	# Set circle color
	var styleBox: StyleBoxFlat = circle.get_theme_stylebox("panel").duplicate()
	styleBox.set("border_color", color)
	circle.add_theme_stylebox_override("panel", styleBox)

func _to_string() -> String:
	return "{0} {1}".format([id, player_name])
	

## Gets a random number of random cards
## Returns [Array] of [Card]
func lie() -> Array:
	var output = []
	var max_num = 3
	
	if hand.cards.size() < 3:
		max_num = hand.cards.size()
		
	# Number of cards to play
	var num_cards = randi_range(1, max_num)
	
	# TODO: Remove numbers that are discarded from game
	# HINT: create an array with posible values and randi_range by index ;) 
	latest_statement = randi_range(0, 9)
	
	for i in num_cards:
		output.append(pop_random_card())
		
	return output
	
## Gets a random number from Player's cards and returns all the cards with the same number
## Returns [Array] of [Card]
func truth() -> Array:
	var output = []
	var random_card = pop_random_card()
	latest_statement = random_card.number
	output.append(random_card)
	for card in hand.cards:
		if card.number == random_card.number:
			output.append(card)
			remove_card(card)
	
	return output


## Removes and returns Cards with selected [code]true[/code]
func pop_selected_cards() -> Array:
	var output = []
	for card in hand.cards:
		if card.selected:
			remove_card(card)
			output.append(card)
	return output

## Gets a random card
func pop_random_card() -> Card:
	var random = randi() % hand.cards.size()
	var random_card = hand.cards[random]
	
	remove_card(random_card)
	
	return random_card

## Removes given [Card] from [Hand]
func remove_card(card: Card) -> void:
	
	var index = hand.cards.find(card);
	if -1 == index or hand.cards.size() <= index:
		printerr("Card %s doesn't exist in the hand." % card.name)
		return
	
	hand.cards.remove_at(index)
	hand.remove_child(card)
	card.set_reveal(false)
	card.move_global(0, 0)
	
	card.unselect()

## Removes given [Card]s from [Hand]
func remove_cards(cards: Array) -> void:
	for card in cards:
		remove_card(card)

func add_card(card: Card):
	hand.add_card(card)


func add_cards(cards: Array):
	for card in cards:
		add_card(card)

func set_player_name(name: String):
	self.player_name = name
	# TODO: update sprite


func set_reveal_cards(value: bool):
	hand.reveal = value
	for card in hand.cards:
		card.set_reveal(value)


func set_hand(hand: Hand):
	print("Set hand")
	self.hand = hand
	self.hand.show_cards()
