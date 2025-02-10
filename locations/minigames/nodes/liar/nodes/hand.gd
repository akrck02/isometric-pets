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
	
func arrange_cards_in_arc()->void:
	var step=180/cards.size()
	var degree=90
	for i in range(cards.size()):
		
		var c:Card=cards[i]
		c.z_index=i
		c.rotation_degrees = degree
		degree-=step
		


## Add a card to the array on the back
func add_card(card: Card):
	print("Added card")
	cards.append(card)
	card.set_reveal(reveal)
	add_child(card)
	card.global_position=global_position
	card.global_rotation=global_rotation
	
	arrange_cards_in_arc()
	
	
