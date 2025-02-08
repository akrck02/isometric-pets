extends Node2D
class_name Player

## Players of the [Liar] minigame
var id: int
var player_name: String = "teko"

## List of [Card]s
var _hand: Hand
var facing: Constants.FACING
var latest_statement: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _to_string() -> String:
	return "{0} {1}".format([id, player_name])

## Gets a random number of random cards
## Returns [Array] of [Card]
func lie()->Array:
	var output=[]
	var max_num=3
	
	if _hand.cards.size()<3:
		max_num=_hand.cards.size()
		
	# Number of cards to play
	var num_cards=randi_range(1,max_num)
	
	# TODO: Remove numbers that are discarded from game
	# HINT: create an array with posible values and randi_range by index ;) 
	latest_statement=randi_range(0,9)
	
	for i in num_cards:
		output.append(pop_random_card())
		
	return output
	
## Gets a random number from Player's cards and returns all the cards with the same number
## Returns [Array] of [Card]
func truth()->Array:
	var output=[]
	var random_card=pop_random_card()
	latest_statement=random_card.number
	output.append(random_card)
	for card in _hand.cards:
		if card.number==random_card.number:
			output.append(card)
			remove_card(card)
	
	return output


## Removes and returns Cards with selected [code]true[/code]
func pop_selected_cards()->Array:
	var output = []
	for card in _hand.cards:
		if card.selected:
			remove_card(card)
			output.append(card)
	return output

## Gets a random card
func pop_random_card()->Card:
	var random = randi() % _hand.cards.size()
	var random_card=_hand.cards[random]
	
	remove_card(random_card)
	
	return random_card

## Removes given [Card] from [Hand]
func remove_card(card: Card)->void:
	
	var index = _hand.cards.find(card);
	if -1 == index or _hand.cards_array.size() <= index:
		printerr("Card %s doesn't exist in the hand." % card.name)
		return
	
	_hand.cards.remove_at(index)
	_hand.cards_array.remove_at(index)
	_hand.remove_child(card)
	card.set_reveal(false)
	card.move_global(0, 0)
	card.unselect()

## Removes given [Card]s from [Hand]
func remove_cards(cards: Array)->void:
	for card in cards:
		remove_card(card)

func add_card(card: Card):
	card.user=self.id
	_hand.add_card(card)


func add_cards(cards: Array):
	for card in cards:
		add_card(card)

func set_player_name(name: String):
	self.player_name = name
	# TODO: update sprite


func set_reveal_cards(value: bool):
	_hand.reveal=value
	for card in _hand.cards:
		card.set_reveal(value)


func set_hand(hand: Hand):
	hand.set_user(id)
	self._hand = hand
	get_parent().add_child(self._hand)
	self._hand.move_local(0, 0)
	self._hand.show_cards()
