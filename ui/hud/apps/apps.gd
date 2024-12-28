extends MarginContainer

## Available apps on the phone
enum AvailableApps {
	Menu,
	Pets,
	Inventory,
	Quests,
	Settings
}

## General
@onready var open_button : Button = $MarginContainer/OpenButton

## Apps
@onready var menu : MarginContainer = $Scroll/Menu
@onready var pets : MarginContainer = $Scroll/Pets
@onready var inventory : MarginContainer = $Scroll/Inventory
@onready var quests : MarginContainer = $Scroll/Quests
@onready var settings : VBoxContainer = $Scroll/Settings
var apps : Array[Node] = []

## App buttons
@onready var pets_button : Button = $Scroll/Menu/Rows/Row1/PetsMargin/PetsButton
@onready var inventory_button : Button = $Scroll/Menu/Rows/Row1/InventoryMargin/InventoryButton
@onready var quests_button : Button = $Scroll/Menu/Rows/Row1/QuestsMargin/QuestsButton
@onready var settings_button : Button = $Scroll/Menu/Rows/Row2/SettingsMargin/SettingsButton

@onready var tween : Tween

var animation_playing : bool = false
var expanded : bool = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(position.x, get_viewport_rect().size.y - 70)	
	apps = [menu, pets, inventory, quests, settings]
	_connect_signals()

	if OSManager.is_desktop(): 
		size.x = 400


## Connect signals to events
func _connect_signals() -> void:
	InputManager.find_requested.connect(_toggle_by_input_data)
	open_button.pressed.connect(toggle)
	pets_button.pressed.connect(open_app.bind(AvailableApps.Pets))
	inventory_button.pressed.connect(open_app.bind(AvailableApps.Inventory))
	quests_button.pressed.connect(open_app.bind(AvailableApps.Quests))
	settings_button.pressed.connect(open_app.bind(AvailableApps.Settings))


## Toggle apps for input data
func _toggle_by_input_data(_data):
	toggle()


## Toggle apps 
func toggle():
	
	if expanded:
		close_menu()
		return
	
	open_menu()


## Open menu
func open_menu() -> void:
	
	if animation_playing: return
	
	animation_playing = true
	InputManager.context = Game.Context.Settings
	open_app(AvailableApps.Menu)
	
	tween = create_tween()
	var new_position = Vector2(position.x,get_viewport_rect().size.y - size.y)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	animation_playing = false
	expanded = true


## Close menu
func close_menu() -> void:
	
	if animation_playing: return
	
	animation_playing = true
	InputManager.context = Game.Context.Camera
	
	tween = create_tween()
	var new_position = Vector2(position.x, get_viewport_rect().size.y - 70)
	tween.tween_property(self, NodeProperties.Position, new_position, 1.00 / 3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	animation_playing = false
	expanded = false


## Open an app
func open_app(app_index : int) -> void: 
	var current_app = apps[app_index]
	
	for app in apps:
		app.hide()
	
	current_app.show()
