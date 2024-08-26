extends Node
class_name Deck
## Class that contains the cards of the game

const PLAYERS = 4
const CARDS_PER_HAND = 10
## Array containing the cards
var cards: Array
enum COLORS_ENUM { red, yellow, green, blue }


var card_scene=preload("res://scenes/liar/card.tscn")

func _init() -> void:
	self.cards = []
	for color in COLORS_ENUM.keys():
		for num in range(10):
			var card=card_scene.instantiate()
			card.color = color
			card.number = num
			cards.append(card)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _to_string() -> String:
	return str(cards)


## Returns a random [Card] while removing it from the [Deck]
func get_random_card() -> Card:
	var random = randi() % cards.size()
	return cards.pop_at(random)


## Generates the hands of the game depending on the
## number of [constant PLAYERS] and [constant CARDS_PER_HAND] [br]
## Returns an [Array] containing [Hand]
func generate_hands() -> Array:
	var hands: Array = []
	var deck = Deck.new()
	var facing = 0
	for player in PLAYERS:
		var hand = Hand.new()
		for c in CARDS_PER_HAND:
			var card = deck.get_random_card()
			card.facing = facing
			hand.facing = facing
			hand.add_card(card)
		hands.append(hand)
		facing += 1

	return hands