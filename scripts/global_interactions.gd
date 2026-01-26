extends Node

@export var debug = true

signal itemGrabbed(idString) #emitted when an item is grabbed in the inventory
signal itemUsed(idString)  #emitted when an item is dropped outside of the inventory
signal interactionOutcome(outcome, idString) #emitted by an interactable when an item is dropped on it
signal itemFound(idString) #emitted when a pickable item is found, adding it to the inventory and removing it from the world
signal itemSelected(idString) #emitted when the player selects an item in the inventory
signal togglePDA()

# Outcome codes for drag/drop interactions
const OUTCOME = {
	"FAIL": -1, #item cannot be used on that interactable, returns to inventory
	"NONE": 0, #item not dropped on an interactable
	"SUCCESS_FINAL": 1, #item is used and does not return to inventory
	"SUCCESS": 2, #item used successfully, returns to inventory
}

func _ready():
	connect("itemGrabbed", onItemGrabbed)
	connect("itemUsed", onItemUsed)
	connect("interactionOutcome", onItemInteraction)
	connect("itemFound", onItemFound)
	connect("itemSelected", onItemSelected)
	connect("togglePDA", onTogglePDA)

func onItemUsed(idString):
	if debug:
		print ("item "+idString+" dropped")
	
func onItemGrabbed(idString):
	if debug: 
		print("item "+idString+" grabbed")

func onItemInteraction(outcome, idString):
	if(outcome == OUTCOME.SUCCESS_FINAL):
		GlobalData.inventory[idString] = false
		GlobalData.currentItem = ""
		
	if debug:
		print("item " + idString + " used; " + OUTCOME.find_key(outcome))

func onItemFound(idString):
	GlobalData.inventory[idString] = true
	GlobalData.game_data["item_"+idString] = false
	if GlobalData.currentItem == "":
		emit_signal("itemSelected", idString)
		
	if debug:
		print("item "+idString+" found")

func onItemSelected(idString):
	print("Item was selected")
	GlobalData.currentItem = idString
	if GlobalData.pda_open:
		GlobalInteractions.togglePDA.emit()
	if debug:
		print("item "+idString+" selected from inventory")
		
func onTogglePDA():
	if debug:
		print("PDA toggled")
