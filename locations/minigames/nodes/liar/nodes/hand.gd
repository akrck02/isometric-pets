extends Node2D
class_name Hand

## Class that represents the list of [Card] objects that a [Player] has

## List of [Card] objects
var cards: Array
var facing: Constants.FACING
var hide: bool = true

## If user can select cards
var selectable: bool = false

func _init() -> void:
	pass

func _to_string() -> String:
	return "hand"+ str(cards)

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


func arrange_cards_in_arc() -> void:
	var step = 90 / cards.size() # Reduce the step to make the arc less wide
	var degree = 45 # Start with a smaller degree for a less wide arc
	var offset = Vector2(20, 0) # Displace to the right by 50 pixels

	for i in range(cards.size()):
		var c: Card = cards[i]
		c.z_index = i
		c.rotation_degrees = degree
		c.position += offset # Displace to the right
		degree -= step
		
	_center()
	
func _center():
	# Center the hand inside its parent node
	var parent_size = get_parent().circle.size.x
	var hand_size = get_combined_bounding_box().size.x
	position.x = (parent_size - hand_size) / 2
	
func arrange_cards_in_line()->void:
	for i in range(cards.size()):
		var c: Card = cards[i]
		c.position.x=i*80+20
	_center()

func get_combined_bounding_box() -> Rect2:
	var rect = Rect2()
	for card: Card in cards:
		rect = rect.merge(Rect2(card.position, card.color_rect.size))
	return rect

	
## Add a card to the array on the back
func add_card(card: Card):
	cards.append(card)
	card.set_hide(hide)
	add_child(card)
	card.global_position = global_position
	card.global_rotation = global_rotation
	
	if hide:
		arrange_cards_in_arc()
	else:
		arrange_cards_in_line()
