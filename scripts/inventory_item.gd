extends Node2D

@export var data: Resource
@export var handPosition = Vector2(1150,850) #stores the on-screen location of the player hand
var dragging = false

func _ready():
	assert(data != null, "no data assigned to inventory item")
	self.position = handPosition
	$Button.button_down.connect(on_grab)
	$Button.button_up.connect(on_use)
	$TextureRect.texture = data.spriteTexture
	
	#show a debug label containing the itemID if the texture false to load
	if data.label:
		$Label.text = data.itemID

func _process(_delta):
	if dragging:
		self.position.x = xoff + get_viewport().get_mouse_position().x
		self.position.y = yoff + get_viewport().get_mouse_position().y

#  store the offset of the mouse click location distance from the center of the node
var xoff = 0 
var yoff = 0

# handle the inventory item being selected
func on_grab():
	GlobalInteractions.emit_signal("itemGrabbed", data.itemID)
	dragging = true
	xoff = self.position.x - get_viewport().get_mouse_position().x
	yoff = self.position.y - get_viewport().get_mouse_position().y

# handles and stores the outcome the item being dropped
var interactionStatus = null
func on_interaction (outcome, _index):
	interactionStatus = outcome

#handle the item being dropped and potentially used
func on_use():
	dragging = false
	
	GlobalInteractions.interactionOutcome.connect(on_interaction, CONNECT_ONE_SHOT)
	
	#notify interactable items that an item was used 
	GlobalInteractions.emit_signal("itemUsed", data.itemID) 
	
	#wait one physics tick for a response signal signifying the item was dropped on an interactable
	await get_tree().create_timer(1.0 / Engine.physics_ticks_per_second).timeout
	
	#no response; decouple event handler and return to inventory
	if interactionStatus == null:
		GlobalInteractions.interactionOutcome.disconnect(on_interaction);
		self.position = handPosition
	elif interactionStatus == GlobalInteractions.OUTCOME.SUCCESS_FINAL:
		#use suceeded and item is used up
		self.free() #delete self 
	elif interactionStatus == GlobalInteractions.OUTCOME.FAIL || interactionStatus == GlobalInteractions.OUTCOME.SUCCESS:
		#Use suceeded but is repeatable, or use failed. Return item to correct on screen position
		self.position = handPosition
