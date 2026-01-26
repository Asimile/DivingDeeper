extends Node2D

var Global = preload("res://scripts/global.gd")
@export var data: Resource
@export var pos = Vector2(0,0)

func _ready():
	assert(data != null, "no data assigned to pickable item")
	self.position = pos
	$TextureRect.texture = data.spriteTexture
	
	#show a debug label containing the itemID if the texture false to load
	if data.label:
		$Label.text = data.itemID
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_press()

func on_press():
	GlobalInteractions.emit_signal("itemFound", data.itemID)
	self.queue_free()

func _process(_delta: float) -> void:
	pass
