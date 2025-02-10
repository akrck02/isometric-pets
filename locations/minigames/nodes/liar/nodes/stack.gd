extends Node2D
class_name Stack
const PLAYERS = 4
const CARDS_PER_HAND = 10
## Array containing the cards
var cards: Array
const card_scene = preload("res://locations/minigames/nodes/liar/nodes/card.tscn");
const hand_scene = preload("res://locations/minigames/nodes/liar/nodes/hand.tscn");
@onready var sprite_2d: Sprite2D = $Sprite2D
var latest_added_cards: Array


func _init() -> void:
	self.cards = []
	for color_name in Constants.COLORS.keys():
		var color = Constants.COLORS[color_name]
		for num in range(10):
			var card_instance = card_scene.instantiate()
			card_instance.color = color
			card_instance.number = num
			card_instance.update_sprite()
			add_child(card_instance)
			cards.append(card_instance)
			


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
	sprite_2d.texture = load(Paths.get_minigame("liar").get_sprite("white_card.png"));


func pop_latest_added_cards():
	var latest_cards = latest_added_cards
	for card in latest_added_cards:
		remove_child(card)
	print_tree()
	latest_added_cards = []
	return latest_cards
	
	
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
	var card=cards.pop_at(random)
	remove_child(card)
	return card
