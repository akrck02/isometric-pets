class_name SaveData

var pets : Dictionary = {}
var quests : Dictionary = {}
var inventory : Dictionary = {}
var minigames : Dictionary = {}


## Set pet
func set_pet(pet : Dictionary) -> void:
	pets[pet.name] = pet


## Get if pet exists
func pet_exists(name : String) -> bool:
	return null != pets.has(name)


## Get pet
func get_pet(name : String) -> Dictionary:
	if not pet_exists(name):
		printerr("Pet %s does not exists." % name)
		return {}
		
	return pets[name]


## Set quest
func set_quest(quest : Dictionary) -> void:
	quests[quest.id] = quest


## Get if quest exists
func quest_exists(id : int) -> bool:
	return quests.has(id)


## Get quest
func get_quest(id : int) -> Dictionary:
	if not quest_exists(id):
		printerr("Quest %s does not exists." % id)
		return {}
	
	return quests[id]


## Set item 
func set_item(item : Dictionary) -> void:
	inventory[item.id] = item


## Get if item exists
func item_exists(id : int) -> bool:
	return inventory.has(id)


## Get item 
func get_item(id: int) -> Dictionary:
	if not item_exists(id):
		printerr("Item %s does not exists." % id)
		return {}
	
	return inventory[id]


## Remove item
func remove_item(id : int) -> void:
	if not item_exists(id):
		printerr("Item %s does not exists." % id)
		return
	
	inventory.erase(id)


## Returns a SaveData object serialized as a String in json format.
func _to_string() -> String:
	var data = {}
	data.pets = pets
	data.quests = quests
	data.inventory = inventory
	data.minigames = minigames
	return JSON.stringify(data,"    ")


## Returns a parsed SaveData object fromn a String in json format.
static func from_json(json : String) -> SaveData:

	var save_data = SaveData.new()
	var parsed_data = JSON.parse_string(json)

	if null == parsed_data:
		return save_data

	var parsed_pets = parsed_data["pets"]
	for pet_name in parsed_pets:
		save_data.set_pet(parsed_pets[pet_name])

	var parsed_quests = parsed_data["quests"]
	for quest_name in parsed_quests:
		save_data.set_quest(parsed_quests[quest_name])

	var parsed_inventory = parsed_data["inventory"]
	for item_name in parsed_inventory:
		save_data.set_item(parsed_inventory[item_name])

	return save_data
