extends IsometricObject
class_name Stack
const PLAYERS = 4
const CARDS_PER_HAND = 10
## Array containing the cards
var cards: Array
enum COLORS_ENUM { red, yellow, green, blue }

var card_scene = preload("res://scenes/liar/card.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D

var latest_added_cards: Array


func _init() -> void:
	self.cards = []
	for color in COLORS_ENUM.keys():
		for num in range(10):
			var card = card_scene.instantiate()
			card.color = color
			card.number = num
			cards.append(card)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func latest_statement_true(latest_statement: int) -> bool:
	for card in latest_added_cards:
		if card.number != latest_statement:
			return false
	return true


func add_card(card: Card):
	cards.append(card)
	card.move_global(0,0)
	add_child(card)
	if cards.size() > 1:
		update_sprite()


func add_cards(cards: Array):
	latest_added_cards = []
	latest_added_cards=cards
	for card in cards:
		add_card(card)


func update_sprite():
	if not sprite_2d:
		return

	sprite_2d.frame = 0
	sprite_2d.hframes = 1
	sprite_2d.vframes = 2
	sprite_2d.texture = load("res://resources/sprites/cards/white.png")


func pop_latest_added_cards():
	var cards = latest_added_cards
	for card in cards:
		remove_child(card)
	print_tree()
	latest_added_cards = []
	return cards
	
	
func pop_cards():
	for card in cards:
		remove_child(card)
	
	var output=cards
	cards=[]
	return output


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
	var facing = 0
	for player in PLAYERS:
		var hand = Hand.new()
		for c in CARDS_PER_HAND:
			var card = self.get_random_card()
			card.facing = facing
			hand.facing = facing
			hand.add_card(card)
		hands.append(hand)
		facing += 1

	return hands
