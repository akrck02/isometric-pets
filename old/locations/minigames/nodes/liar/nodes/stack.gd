extends CardGroup
class_name Stack
const PLAYERS = 4
const CARDS_PER_HAND = 10
const card_scene = preload("res://locations/minigames/nodes/liar/nodes/card.tscn");
const hand_scene = preload("res://locations/minigames/nodes/liar/nodes/hand.tscn");
var latest_added_cards: Array


func latest_statement_true(latest_statement: int) -> bool:
	for card in latest_added_cards:
		if card.number != latest_statement:
			return false
	return true

func add_cards(cards: Array, show_cards: bool = false):
	latest_added_cards = []
	latest_added_cards = cards
	super(cards)
	
func pop_cards():
	var output = []
	for card in cards_array:
		if card != null:
			output.append(card)
	cards_array.resize(40)
	return output

func _to_string() -> String:
	return "stack: " + str(cards_array)
