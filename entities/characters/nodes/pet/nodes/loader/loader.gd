extends Node2D
class_name PetLoader

signal load_pet_requested()

const PET_SERVICE : String = "http://slimbook-executive-16:3000/isopets/1.0"
const GET_PET_SERVICE : String = PET_SERVICE + "/pets/%s"
const GET_PET_IMAGE_SERVICE : String = GET_PET_SERVICE + "/image"

@export_category("Dependencies")
@export var sprite : Sprite2D

@export_category("Stats")
@export var uuid = "8dc87417-f4e5-4b39-a3f0-21534f68a6b4";

@onready var dependencies : DependencyDatabase = DependencyDatabase.for_node("PetLoader")
@onready var http_request : HTTPRequest = $HTTPRequest

func _ready() -> void:
	dependencies.add("sprite", sprite)
	dependencies.check()
	_connect_signals()
	

func _connect_signals() -> void:
	load_pet_requested.connect(_request_load_pet)


func _request_load_pet() -> void:	
	http_request.request(GET_PET_IMAGE_SERVICE % uuid)
	print(GET_PET_IMAGE_SERVICE % uuid)
	http_request.request_completed.connect(_load_pet)


func _load_pet(_result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		
	if response_code != 200:
		printerr("Error %s" % response_code)
		return
	
	var img : Image = Image.new()
	img.load_png_from_buffer(body)
	
	var path : String = Paths.get_character("pet").get_path() + "/sprites/%s.png" % uuid;
	
	var error : Error = img.save_png(path)
	if error:
		printerr(error)
		return
	
	sprite.texture = ImageTexture.create_from_image(img)
