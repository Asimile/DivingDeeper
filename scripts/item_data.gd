class_name ItemData
extends Resource

@export var itemID: String # identifier for which object it is
@export var spriteTexture: Resource # path to texture resource

func _init(id = "defualtItem", texture = "res://icon.svg"):
	itemID = id
	spriteTexture = load(texture)
