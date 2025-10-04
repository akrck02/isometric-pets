extends CardGroup
class_name Hand


## If user can select cards
var selectable: bool = false

func _to_string() -> String:
	return "hand" + str(cards_array)

## Shows all [Card] objects in the [Hand]
func set_show_cards(value: bool) -> void:
	for card: Card in self.cards_array:
		if card != null:
			card.set_show(value)


func set_selectable(value: bool):
	self.selectable = value
	for card in cards_array:
		if card == null:
			continue
		card.set_selectable(value)


## Unselect all cards in hand
func unselect():
	for card: Card in cards_array:
		if card == null:
			continue
		card.unselect()
