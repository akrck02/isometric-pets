extends CardGroup
class_name Hand

## Class that represents the list of [Card] objects that a [Player] has

## List of [Card] objects
var facing: Constants.FACING

## If user can select cards
var selectable: bool = false



func _to_string() -> String:
	return "hand" + str(cards_array)

## Shows all [Card] objects in the [Hand]
func set_show_cards(value: bool) -> void:
	for card: Card in self.cards:
		card.show_card = value


func set_selectable(value: bool):
	self.selectable = value
	for card in cards_array:
		if card == null:
			continue
		card.set_selectable(value)


## Unselect all cards in hand
func unselect():
	for card in cards_array:
		if card == null:
			continue
		card.unselect()


func get_selected_cards() -> Array:
	var output = []
	for card in cards_array:
		if card == null:
			continue
		if card.selected:
			output.append(card)

	return output
