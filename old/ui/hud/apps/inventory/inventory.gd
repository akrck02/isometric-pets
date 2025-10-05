extends App

@export var items: Array[Item]
@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = $VBoxContainer/GridContainer.get_children()


func open() -> void:
	super()
	var index= 3
	for item in items:
		for slot in slots:
			if !slot.slot_item:
				slot.update(item, index)
				index+=1
				break
		

	
