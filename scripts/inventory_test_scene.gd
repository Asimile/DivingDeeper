extends Node2D

var Data = preload("res://scripts/item_data.gd")
var Item = preload("res://scenes/inventory_item.tscn")
var Interactable = preload("res://scenes/interactable_object.tscn")
var PickableItem = preload("res://scenes/pickable_item.tscn")

func _ready():
	var data = [
		Data.new("wrench"),
		Data.new("item"),
	]
	
	var items = []
	
	for i in data.size():
		items.append(Item.instantiate())
		items[i].data = data[i]
		items[i].visible = true
		add_child(items[i])
	
	#add a trash can which only accepts items with the id "item" and deletes them on use
	var trash = Interactable.instantiate()
	trash.objectName = "trashcan"
	trash.position = Vector2(250,200)
	
	trash.on_interaction = func(idString):
		if(idString == "item"):
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS_FINAL, idString)
		else:
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, idString)
	
	add_child(trash)
	
	#add a switch that rotates when the wrench is used on it
	var switch = Interactable.instantiate()
	switch.objectName = "switch"
	switch.position = Vector2(350,200)
	
	switch.on_interaction = func(idString):
		if(idString == "wrench"):
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS, idString)
			switch.rotate(PI)
		else:
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, idString)
			
	add_child(switch)
	
	var pickable = PickableItem.instantiate()
	pickable.data = Data.new("icon")
	pickable.visible = true
	pickable.position = Vector2(200,200)
	add_child(pickable)
