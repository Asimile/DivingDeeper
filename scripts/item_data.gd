class_name ItemData
extends Resource

@export var index: int # inventory slot the item belongs to
@export var itemID: String # identifier for which object it is
@export var homePosition: Vector2 # position on screen of inventory slot
@export var spriteTexture: Resource # path to texture resource

func _init(id = "tool", texture = "res://icon.svg", pos=Vector2(0,0), i=0):
	index = i
	itemID = id
	homePosition = pos
	spriteTexture = load(texture)
