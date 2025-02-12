extends Node2D
class_name CardGroup

var free_position: int = 0
var cards = []
@export var show_cards: bool = false

func add_card(card: Card):
	card.set_show(show_cards)
	cards.append(card)
	if card.get_parent() != null:
		print("Reparent")
		card.reparent(self)
	else:
		add_child(card)
	var tween = create_tween()
	tween.tween_property(card, NodeProperties.GlobalPosition, self.global_position, 0.5).set_trans(Tween.TRANS_EXPO)
	if self is not Stack:
		tween.tween_property(card, NodeProperties.Rotation, self.rotation, 0.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	
func remove_card_from_array(card: Card):
	var index = cards.find(card)
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
	var step = 90.0 / cards.size() # Reduce the step to make the arc less wide
	var degree = 45 # Start with a smaller degree for a less wide arc
	var offset = Vector2(20, 0) # Displace to the right by 50 pixels

	for i in range(cards.size()):
		var c: Card = cards[i]
		c.z_index = i
		var tween=create_tween()
		tween.tween_property(c, NodeProperties.Rotation, deg_to_rad(degree), 0.1).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(c, NodeProperties.Position,c.position+offset, 0.1).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		degree -= step
		
		#_center()
		
	print(self.position)
	
func _center():
	# Center the hand inside its parent node
	var parent_size = get_parent().circle.size.x
	var hand_size = get_combined_bounding_box().size.x
	var tween=create_tween()
	tween.tween_property(self, NodeProperties.Position, Vector2((parent_size - hand_size) / 2,self.position.y), 0.1).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	
func arrange_cards_in_line() -> void:
	for i in range(cards.size()):
		var c: Card = cards[i]
		var tween=create_tween()
		tween.tween_property(c, NodeProperties.Position, Vector2(i * 80 + 20,0), 0.1).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		tween.kill()
		_center()

func get_combined_bounding_box() -> Rect2:
	var rect = Rect2()
	for card: Card in cards:
		if card.color_rect == null:
			continue
		rect = rect.merge(Rect2(card.position, card.color_rect.size))
	return rect
