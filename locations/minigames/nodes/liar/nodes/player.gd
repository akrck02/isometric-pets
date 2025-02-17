extends Node2D
class_name Player

enum PLAYER_TYPE {
	NPC,
	PET
}

## Players of the [Liar] minigame
@export var id: int
@export var player_name: String = "teko"
@export var player_type: PLAYER_TYPE = PLAYER_TYPE.NPC
@export var show_cards: bool
@export var color: Color
@export var card_organization: Constants.CARD_ORGANIZATION = Constants.CARD_ORGANIZATION.ARC

# Nodes
@onready var hand: Hand = $Hand
@onready var circle: Panel = $Circle
@onready var visuals: PetVisuals = $Visuals

var latest_statement: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var character = "npc"
	if player_type == PLAYER_TYPE.PET:
		character = "pet"
	
	visuals.pet_name=player_name
	visuals.sprite.texture = load(Paths.get_character(character).get_sprite("%s.png" % player_name))
	visuals.scale=Vector2(1.8,1.8)
	visuals.animation_player.play("idle")
	
	# Set if cards in hand are hidden
	hand.show_cards = show_cards

	# Set how cards are organized in the game
	hand.organization = card_organization
	
	# Set circle color
	var styleBox: StyleBoxFlat = circle.get_theme_stylebox("panel").duplicate()
	styleBox.set("border_color", color)
	circle.add_theme_stylebox_override("panel", styleBox)

func _to_string() -> String:
	return "{0} {1}".format([id, player_name])

## Gets a random number of random cards
## Returns [Array] of [Card]
func lie() -> Array:
	var output = []
	var max_num = 3
	
	if hand.cards_array.size() < 3:
		max_num = hand.cards_array.size()
		
	# Number of cards to play
	var num_cards = randi_range(1, max_num)
	
	# TODO: Remove numbers that are discarded from game
	# HINT: create an array with posible values and randi_range by index ;) 
	latest_statement = randi_range(0, 9)
	
	for i in num_cards:
		output.append(pop_random_card())
		
	return output
	
## Gets a random number from Player's cards and returns all the cards with the same number
## Returns [Array] of [Card]
func truth() -> Array:
	var output = []
	var random_card = pop_random_card()
	latest_statement = random_card.number
	output.append(random_card)
	for card in hand.cards_array:
		if card != null and card.number == random_card.number:
			output.append(card)
			_remove_card(card)
	
	return output


## Gets a random card
func pop_random_card() -> Card:
	# Filter out null values
	var non_null_cards = hand.cards_array.filter(func(card):
		return card != null
	)
	
	if non_null_cards.size() == 0:
		return null # Return null if there are no non-null cards

	# Get a random index from the non-null cards
	var random_index = randi() % non_null_cards.size()
	var random_card = non_null_cards[random_index]
	
	_remove_card(random_card)
	
	return random_card

## Removes given [Card] from [Hand]
func _remove_card(card: Card) -> void:
	var index = hand.cards_array.find(card);
	if -1 == index or hand.cards_array.size() <= index:
		printerr("Card %s doesn't exist in the hand." % card.name)
		return
	
	card.unselect()
	hand.cards_array[index] = null
	card.set_show(false)
