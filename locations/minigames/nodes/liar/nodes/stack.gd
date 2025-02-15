extends CardGroup
class_name Stack
const PLAYERS = 4
const CARDS_PER_HAND = 10
## Array containing the cards
const card_scene = preload("res://locations/minigames/nodes/liar/nodes/card.tscn");
const hand_scene = preload("res://locations/minigames/nodes/liar/nodes/hand.tscn");
@onready var sprite_2d: Sprite2D = $Sprite2D
var latest_added_cards: Array


func latest_statement_true(latest_statement: int) -> bool:
	for card in latest_added_cards:
		if card.number != latest_statement:
			return false
	return true


func add_cards(cards: Array):
	latest_added_cards = []
	latest_added_cards = cards
	super(cards)


func update_sprite():
	if not sprite_2d:
		return


func pop_latest_added_cards():
	var latest_cards = latest_added_cards
	for card in latest_added_cards:
		remove_child(card)
	print_tree()
	latest_added_cards = []
	return latest_cards
	
	
func pop_cards():
	var output = []
	for card in cards_array:
		if card != null:
			output.append(card)
	cards_array = []
	return output


func _to_string() -> String:
	return "stack: " + str(cards_array)


## Returns a random [Card] while removing it from the [Deck]
func get_random_card() -> Card:
	# Filter out null elements
	var non_null_cards = cards_array.filter(func(card):
		return card != null
	)
	
	if non_null_cards.size() == 0:
		return null # Return null if there are no non-null cards

	# Get a random index from the non-null cards
	var random_index = randi() % non_null_cards.size()
	var card = non_null_cards[random_index]

	# Remove the card from the original cards_array
	var original_index = cards_array.find(card)
	cards_array[original_index] = null

	remove_child(card)
	return card
