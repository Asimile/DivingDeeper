extends Node

@export var debug = true

signal itemGrabbed(itemIndex) #emitted when an item is grabbed in the inventory
signal itemUsed(index)  #emitted when an item is dropped outside of the inventory
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

func onItemUsed(index):
	if debug:
		print("item " + str(index) + " dropped")
	
func onItemGrabbed(i):
	if debug: 
		print("item " + str(i) + " grabbed")

func onItemInteraction(outcome, i):
	if debug:
		print("item " + str(i) + " used, interaction: " + OUTCOME.find_key(outcome))
