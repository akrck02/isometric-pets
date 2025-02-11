extends Node2D
class_name CardGroup

var free_position:int=0
var cards = []
@export var show_cards:bool = false


func add_card(card:Card):
	cards.append(card)
	var tween = create_tween()
	tween.tween_property(card, NodeProperties.GlobalPosition, Vector2(0,0),0.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	if card.get_parent()!=null:
		print("Reparent")
		card.reparent(self)
	else:
		add_child(card)
	card.set_show(show_cards)
	
func remove_card_from_array(card: Card):
	var index=cards.find(card)
	cards.remove_at(index)
	
func remove_cards_from_array(cards: Array):
	for card in cards:
		remove_card_from_array(card)
		
func get_selected_cards() -> Array:
	return cards.filter(func(card):
		return card.selected
	)

func pop_selected_cards() -> Array:
	var output = get_selected_cards()
	remove_cards_from_array(output)
	return output
func arrange_cards_in_arc() -> void:
	if cards.is_empty():
		return
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
		if card.color_rect==null:
			continue
		rect = rect.merge(Rect2(card.position, card.color_rect.size))
	return rect
