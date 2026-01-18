extends Node2D

@export var data: Resource
var dragging = false

func _ready():
	assert(data != null, "no data assigned to inventory item")
	self.position = data.homePosition
	$Button.button_down.connect(on_grab)
	$Button.button_up.connect(on_use)
	$TextureRect.texture = data.spriteTexture

func _process(_delta):
	if dragging:
		self.position.x = xoff + get_viewport().get_mouse_position().x
		self.position.y = yoff + get_viewport().get_mouse_position().y

#  store the offset of the mouse click location distance from the center of the node
var xoff = 0 
var yoff = 0

# handle the inventory item being selected
func on_grab():
	GlobalInteractions.emit_signal("itemGrabbed", data.index)
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
		self.position = data.homePosition
	
	if interactionStatus == GlobalInteractions.OUTCOME.FAIL || interactionStatus == GlobalInteractions.OUTCOME.SUCCESS:
		#return item to correct on screen position
		self.position = data.homePosition 
	
	if interactionStatus == GlobalInteractions.OUTCOME.SUCCESS_FINAL:
		#TODO notify inventory system that item was deleted
		#TODO have inventory manager delete item instance
		self.free() #delete self 
