class_name ItemData
extends Resource

@export var itemID: String # identifier for which object it is
@export var spriteTexture: Resource # path to texture resource
var label = false 

func _init(id = "defualtItem"):
	itemID = id
	if not ResourceLoader.exists("res://assets/sprites/"+itemID+".png"):
		spriteTexture = load("res://icon.svg")
		label = true #show a debug label containing the itemID if the texture false to load
		push_warning("No sprite exists for '"+itemID+"',")
	else:
		spriteTexture = load("res://assets/sprites/"+itemID+".png")
