extends Node
signal youWin()

# Global center for game data needed in many or all scenes

# Keeps track of what items have been taken, doors opened, etc so that each newly initialized scene knows
# what items it can remove before the player sees them.
var game_data = {
	"item_wrench" = true,
	"item_key" = true,
	"power_on" = true
}

#stores the item the player is holding. must match an itemID in inventory, and that ID must be true (found)
#empty string means no item held
var currentItem = ""
var pda_open = false

# Keeps track of items still available in the player's inventory. False means that the itme either has not
# been found, or has been used up. True means it should be visible in the inventory
var inventory = {
	"wrench" = false,
	"key" = false
}

var itemsCollected = {
	"wrench" = false,
	"key" = false
}
