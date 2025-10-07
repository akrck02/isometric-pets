extends App

@export var items: Array[Item]
@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = $VBoxContainer/GridContainer.get_children()
@onready var next_page_button: Button = $VBoxContainer/HBoxContainer/NextPageButton
@onready var prev_page_button: Button = $VBoxContainer/HBoxContainer/PrevPageButton
var onigiri = preload("res://entities/items/nodes/food/oniguiri.tres")   

const ITEMS_PER_PAGE = 20
var current_page = 0
var last_page = 1



func _ready() -> void:
	next_page_button.pressed.connect(_next_page)
	prev_page_button.pressed.connect(_prev_page)
	for i in range(50):
		items.append(onigiri.duplicate())
		
	last_page = ceil(float(items.size()) / ITEMS_PER_PAGE) - 1
	
	

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
			slots[slot_index].update(item,10*current_page+slot_index)
			slot_index+=1
			
func _empty_slots():
	for slot in slots:
		slot.empty()

func open() -> void:
	super()
	_update_slots()
