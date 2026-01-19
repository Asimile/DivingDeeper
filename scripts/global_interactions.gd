extends Node

@export var debug = true

signal itemGrabbed(index) #emitted when an item is grabbed in the inventory
signal itemUsed(idString, index)  #emitted when an item is dropped outside of the inventory
signal interactionOutcome(outcome, index) #emitted by an interactable when an item is dropped on it

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

func onItemUsed(idString, i):
	if debug:
		print (idString+" in slot "+str(i)+" dropped")
	
func onItemGrabbed(i):
	if debug: 
		print("item in slot "+str(i)+" grabbed")

func onItemInteraction(outcome, i):
	if debug:
		print("item in slot " + str(i) + " used " + OUTCOME.find_key(outcome))
