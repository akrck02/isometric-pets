extends Node2D
class_name CardGroup


var free_positions: Array = []
var cards_array = []
var cards_per_line: int = 10
var card_width = 80
@export var show_cards: bool = false
@export var organization: Constants.CARD_ORGANIZATION = Constants.CARD_ORGANIZATION.ARC

func _init() -> void:
	for x in 40:
		free_positions.append(x)
func _ready() -> void:
	cards_per_line = DisplayServer.screen_get_size().x / card_width
	cards_array.resize(40)

func add_cards(cards: Array):
	var tween = create_tween()
	print("free_positions1 "+ str(free_positions))
	
	for i in range(cards.size()):
		var card = cards[i]
		if card.get_parent() != null:
			card.reparent(self)
		else:
			add_child(card)
			
		var free_position = free_positions.pop_at(i)
		print(free_position)
		cards_array.insert(free_position, card)
		
		var test = self.global_position
		test = to_global(Vector2(free_position * 80 + 20, 0))
		
		match organization:
			Constants.CARD_ORGANIZATION.LINE: # HAND
				tween.parallel().tween_property(card, NodeProperties.Rotation, self.rotation, 0.5).set_trans(Tween.TRANS_EXPO)
				tween.parallel().tween_property(card, NodeProperties.GlobalPosition, test, 0.5).set_trans(Tween.TRANS_EXPO)
			Constants.CARD_ORGANIZATION.ARC: # HAND
				tween.parallel().tween_property(card, NodeProperties.GlobalPosition, test, 0.5).set_trans(Tween.TRANS_EXPO)
			Constants.CARD_ORGANIZATION.PILE: # STACK
				tween.parallel().tween_property(card, NodeProperties.GlobalPosition, self.global_position, 0.5).set_trans(Tween.TRANS_EXPO)
		
	await tween.finished
	tween.kill()
		
func add_card(card: Card):
	card.set_show(show_cards)
	if card.get_parent() != null:
		card.reparent(self)
	else:
		add_child(card)
	
	var free_position = free_positions.pop_front()
	cards_array.insert(free_position, card)
	
	var test = self.global_position
	test = to_global(Vector2(free_position * 80 + 20, 0))
	
	var tween = create_tween()
	match organization:
		Constants.CARD_ORGANIZATION.LINE: # HAND
			tween.tween_property(card, NodeProperties.Rotation, self.rotation, 0.5).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(card, NodeProperties.GlobalPosition, test, 0.5).set_trans(Tween.TRANS_EXPO)
		Constants.CARD_ORGANIZATION.ARC: # HAND
			tween.tween_property(card, NodeProperties.GlobalPosition, test, 0.5).set_trans(Tween.TRANS_EXPO)
		Constants.CARD_ORGANIZATION.PILE: # STACK
			tween.tween_property(card, NodeProperties.GlobalPosition, self.global_position, 0.5).set_trans(Tween.TRANS_EXPO)
	
	await tween.finished
	tween.kill()
	
func remove_card_from_array(card: Card):
	var index = cards_array.find(card)
	cards_array.remove_at(index)
	free_positions.append(index)
	free_positions.sort()
	
func _get_free_position() -> int:
	for i in range(cards_array.size()):
		if cards_array[i] == null:
			return i
	return -1
	
func remove_cards_from_array(cards: Array):
	for card in cards:
		if card == null:
			continue
		remove_card_from_array(card)
		
func get_selected_cards() -> Array:
	return cards_array.filter(func(card):
		return card != null && card.selected
	)

func pop_selected_cards() -> Array:
	var output = get_selected_cards()
	remove_cards_from_array(output)
	return output


func arrange_cards() -> void:
	if organization == Constants.CARD_ORGANIZATION.LINE:
		arrange_cards_in_line()
	else:
		arrange_cards_in_arc()

func arrange_cards_in_arc() -> void:
	if cards_array.is_empty():
		return
	var step = 90.0 / cards_array.size() # Reduce the step to make the arc less wide
	var degree = 45 # Start with a smaller degree for a less wide arc
	var offset = Vector2(20, 0) # Displace to the right by 50 pixels

	for i in range(cards_array.size()):
		if cards_array[i] == null:
			continue
		var c: Card = cards_array[i]
		c.z_index = i
		var tween = create_tween()
		tween.tween_property(c, NodeProperties.Rotation, deg_to_rad(degree), 0.1).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(c, NodeProperties.Position, c.position + offset, 0.1).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		degree -= step
		
		#_center()
		
	
func _center():
	# Center the hand inside its parent node
	var parent_size = get_parent().circle.size.x
	var hand_size = get_combined_bounding_box().size.x
	var new_global_x = get_parent().global_position.x + (parent_size - hand_size) / 2

	var tween = create_tween()
	tween.tween_property(self, NodeProperties.GlobalPosition, Vector2(new_global_x, global_position.y), 0.1).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	
func arrange_cards_in_line() -> void:
	for i in range(cards_array.size()):
		if cards_array[i] == null:
			continue
		var c: Card = cards_array[i]
		var test = self.global_position
		var free_position = free_positions.pop_front()
		test = to_global(Vector2(free_position * 80 + 20, 0))
		var tween = create_tween()
		tween.tween_property(c, NodeProperties.GlobalPosition, test, 0.1).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		tween.kill()

func get_combined_bounding_box() -> Rect2:
	var rect = Rect2()
	for card: Card in cards_array:
		if card == null:
			continue
		if card.color_rect == null:
			continue
		rect = rect.merge(Rect2(card.position, card.color_rect.size))
	return rect
