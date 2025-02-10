extends Node2D
class_name Hand

## Class that represents the list of [Card] objects that a [Player] has

## List of [Card] objects
var cards: Array
var facing: Constants.FACING
var reveal: bool = false

## If user can select cards
var selectable: bool = false

func _init() -> void:
	pass

func _to_string() -> String:
	return str(cards)

## Shows all [Card] objects in the [Hand]
func show_cards():
	for card in self.cards:
		card.show_card_sprite()

func set_user(value: int):
	for card in cards:
		card.user = value

func set_selectable(value: bool):
	self.selectable = value
	for card in cards:
		card.set_selectable(value)


## Unselect all cards in hand
func unselect():
	for card in cards:
		card.unselect()


func get_selected_cards() -> Array:
	var output = []
	for card in cards:
		if card.selected:
			output.append(card)

	return output


## Add a card to the array on the back
func add_card(card: Card):
	print("Added card")
	cards.append(card)
	add_child(card)
	card.move_local_x(global_position.x+50*cards.size())
	card.move_local_y(global_position.y)
	card.set_reveal(reveal)
	card.show_card_sprite()
	
	
