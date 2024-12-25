class_name SaveData

var pets : Dictionary = {}
var quests : Dictionary = {}
var inventory : Dictionary = {}
var minigames : Dictionary = {}

func set_pet(pet : Dictionary) -> void:
	pets[pet.name] = pet

func set_quest() -> void:
	pass

func set_item() -> void:
	pass

func remove_item() -> void:
	pass


## Returns a SaveData object serialized as a String in json format.
func _to_string() -> String:
	var data = {
		"pets" : pets,
		"quests" : quests,
		"inventory" : inventory,
		"minigames" : minigames
	}
	
	return JSON.stringify(data,"    ")


## Returns a parsed SaveData object fromn a String in json format.
static func from_json(json : String) -> SaveData:

	var save_data = SaveData.new()
	var parsed_data = JSON.parse_string(json)

	for pet in parsed_data["pets"]:
		print(pet)
		save_data.set_pet(parsed_data["pets"][pet])

	for quest in parsed_data["quests"]:
		print(quest)
		save_data.set_quest()

	for item in parsed_data["inventory"]:
		print(item)
		save_data.set_item()

	return save_data
