extends Node2D
class_name PetLoader

signal load_pet_requested()

const PET_SERVICE : String = "http://isopets.duckdns.org:3000/isopets/1.0"
const GET_PET_SERVICE : String = PET_SERVICE + "/pets/%s"
const GET_PET_IMAGE_SERVICE : String = GET_PET_SERVICE + "/image"

@export_category("Dependencies")
@export var sprite : Sprite2D
@export var animator : AnimationPlayer

@export_category("Stats")
@export var uuid = "";
var loaded : bool = false;

@onready var dependencies : DependencyDatabase = DependencyDatabase.for_node("PetLoader")
@onready var http_request : HTTPRequest = $HTTPRequest

func _ready() -> void:
	dependencies.add("sprite", sprite)
	dependencies.add("animator", animator)
	dependencies.check()
	_connect_signals()


func _connect_signals() -> void:
	load_pet_requested.connect(_request_load_pet)
	http_request.request_completed.connect(_load_pet)


func _request_load_pet() -> void:
	
	if loaded:
		return
	
	print(GET_PET_IMAGE_SERVICE % uuid)
	http_request.request(GET_PET_IMAGE_SERVICE % uuid)


func _load_pet(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
		
	if response_code != 200:
		printerr("Error %s" % response_code)
		return
	
	var img : Image = Image.new()
	img.load_png_from_buffer(body)
	
	# var path : String = Paths.get_character("pet").get_path() + "/sprites/%s.png" % uuid;
#	var error : Error = img.save_png(path)
#	if error:
#		printerr(error)
#		return
	
	animator.play("disappear")
	await animator.animation_finished
	sprite.texture = ImageTexture.create_from_image(img)
	animator.play("appear")
	await animator.animation_finished
	loaded = true
