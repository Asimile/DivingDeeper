extends Node2D

@export var itemID : String
@export var displayName : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texturePath = "res://assets/sprites/"+itemID+".png"
	var spriteTexture
	if ResourceLoader.exists(texturePath):
		spriteTexture = load(texturePath)
	else:
		spriteTexture = load("res://icon.svg")
		push_warning("No sprite exists for item '"+itemID+"',")
	$Area2D/TextureRect.texture = spriteTexture
	$Area2D/Label.text = displayName
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(GlobalData.inventory.has(itemID)):
		visible = GlobalData.inventory[itemID]

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_press()

func on_press():
	GlobalInteractions.emit_signal("itemSelected", itemID)
