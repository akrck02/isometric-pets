extends App
class_name Inventory

@export var items: Array[Item]
@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = $VBoxContainer/GridContainer.get_children()
@onready var next_page_button: Button = $VBoxContainer/HBoxContainer/NextPageButton
@onready var prev_page_button: Button = $VBoxContainer/HBoxContainer/PrevPageButton
@onready var actions: MarginContainer = $Actions
@onready var actions_back_button: Button = $Actions/MarginContainer/VBoxContainer2/ActionsBackButton
@onready var selected_item_label: Label = $Actions/MarginContainer/VBoxContainer2/HBoxContainer/SelectedItemLabel
@onready var selected_item_texture_rect: TextureRect = $Actions/MarginContainer/VBoxContainer2/HBoxContainer/SelectedItemTextureRect
@onready var selected_item_description: Label = $Actions/MarginContainer/VBoxContainer2/SelectedItemDescription
@onready var action_1_button: Button = $Actions/MarginContainer/VBoxContainer2/Action1Button
@onready var action_2_button: Button = $Actions/MarginContainer/VBoxContainer2/Action2Button


const ONIGUIRI = preload("res://entities/items/nodes/food/oniguiri.tres") 
const CHEESECAKE = preload("res://entities/items/nodes/food/cheesecake.tres")
const CHOCOLATE_CAKE = preload("res://entities/items/nodes/food/chocolate_cake.tres")
const RED_VELVET = preload("res://entities/items/nodes/food/red_velvet.tres")

const ITEMS_PER_PAGE = 20
var selected_slot:InvUiSlot = null
var current_page = 0
var last_page = 1

func _on_slot_clicked():
	actions.visible=true


func _ready() -> void:
	next_page_button.pressed.connect(_next_page)
	prev_page_button.pressed.connect(_prev_page)
	actions_back_button.pressed.connect(_close_actions)
	items.append(CHEESECAKE.duplicate())
	items.append(CHOCOLATE_CAKE.duplicate())
	items.append(RED_VELVET.duplicate())
	
	for i in range(50):
		items.append(ONIGUIRI.duplicate())
	last_page = ceil(float(items.size()) / ITEMS_PER_PAGE) - 1

func _close_actions():
	actions.visible=false
	
func open_actions(item:Item):
	actions.visible=true
	selected_item_label.text=item.item_name
	selected_item_description.text=item.item_description
	selected_item_texture_rect.texture=item.item_texture
	match item.item_type:
		ItemType.ItemType.FOOD:
			action_1_button.text="Eat"
		ItemType.ItemType.FURNITURE:
			action_1_button.text="Place"

func _get_current_page_items():
	var start = current_page * ITEMS_PER_PAGE
	var end = min(start + ITEMS_PER_PAGE, items.size())
	return items.slice(start, end)
	
func _show_or_hide_buttons():
	if current_page==0:
		next_page_button.visible=true
		prev_page_button.visible=false
	elif current_page==last_page:
		next_page_button.visible=false
		prev_page_button.visible=true
	else:
		next_page_button.visible=true
		prev_page_button.visible=true

func _next_page():
	if (current_page + 1) * ITEMS_PER_PAGE < items.size():
		current_page += 1
		
	_show_or_hide_buttons()
	_update_slots()

func _prev_page():
	if current_page > 0:
		current_page -= 1
		
	_show_or_hide_buttons()
	_update_slots()
			
func _update_slots():
	_empty_slots()
	var slot_index= 0
	for item in _get_current_page_items():
		if slot_index<20:
			slots[slot_index].update(item,10*current_page+slot_index+1)
			slot_index+=1
			
func _empty_slots():
	for slot in slots:
		slot.empty()

func open() -> void:
	super()
	_update_slots()
