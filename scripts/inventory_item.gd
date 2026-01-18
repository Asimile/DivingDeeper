extends Node2D

@export var homePosition = Vector2(0,0) #the canvas location of the items inventory slot
@export var index = 0; #the inventory slot this item belongs to

var dragging = false

func _ready():
	$Button.button_down.connect(on_grab)
	$Button.button_up.connect(on_use)

func _process(_delta):
	if dragging:
		self.position.x = xoff + get_viewport().get_mouse_position().x
		self.position.y = yoff + get_viewport().get_mouse_position().y

#  store the offset of the mouse click location distance from the center of the node
var xoff = 0 
var yoff = 0

# handle the inventory item being selected
func on_grab():
	GlobalInteractions.emit_signal("itemGrabbed", index)
	dragging = true
	xoff = self.position.x - get_viewport().get_mouse_position().x
	yoff = self.position.y - get_viewport().get_mouse_position().y

# handles and stores the outcome the item being dropped
var interactionStatus = null
func on_interaction (_index, status):
	interactionStatus = status

#handle the item being dropped and potentially used
func on_use():
	dragging = false
	
	#notify interactable items that an item was used 
	GlobalInteractions.emit_signal("itemUsed", self.position) 
	
	#wait one frame for a response signal signifying the item was dropped on an interactable
	GlobalInteractions.inventoryItemInteraction.connect(on_interaction, CONNECT_ONE_SHOT)
	await get_tree().process_frame
	
	#no response; decouple event handler and return to inventory
	if interactionStatus == null:
		GlobalInteractions.inventoryItemInteraction.disconnect(on_interaction);
		self.position = homePosition
		if GlobalInteractions.debug:
			GlobalInteractions.emit_signal("interactionOutcome", index, GlobalInteractions.OUTCOME.NONE)
	
	if (interactionStatus == GlobalInteractions.OUTCOME.FAIL || interactionStatus == GlobalInteractions.OUTCOME.SUCCESS):
		#return item to correct on screen position
		self.position = homePosition 
	
	if (interactionStatus == GlobalInteractions.OUTCOME.SUCCESS_FINAL):
		#delete self (item was used up)
		self.queue_free()
		#TODO notify inventory system that item was deleted
