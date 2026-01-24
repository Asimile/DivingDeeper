extends Node2D

var Data = preload("res://scripts/item_data.gd")
var Item = preload("res://scenes/inventory_item.tscn")
var Interactable = preload("res://scenes/interactable_object.tscn")
var PickableItem = preload("res://scenes/pickable_item.tscn")

var trashIcon = preload("res://assets_temp/trash.png")
var switchIcon = preload("res://assets_temp/switch.png")

func _ready():
	var data = [
		Data.new("wrench", "res://assets_temp/settings.png", Vector2(40,40), 0),
		Data.new("item", "res://icon.svg", Vector2(140,40), 1),
	]
	
	var items = []
	
	for i in data.size():
		items.append(Item.instantiate())
		items[i].data = data[i]
		add_child(items[i])
	
	#add a trash can which only accepts items with the id "item" and deletes them on use
	var trash = Interactable.instantiate()
	trash.texture = trashIcon
	trash.translate(Vector2(250,200))
	
	trash.on_interaction = func(idString, index):
		if(idString == "item"):
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS_FINAL, index)
		else:
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, index)
	
	add_child(trash)
	
	#add a switch that rotates when the wrench is used on it
	var switch = Interactable.instantiate()
	switch.texture = switchIcon
	switch.translate(Vector2(350,200))
	
	switch.on_interaction = func(idString, index):
		if(idString == "wrench"):
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS, index)
			switch.rotate(PI)
		else:
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, index)
			
	add_child(switch)
	
	var pickable = PickableItem.instantiate()
	pickable.data = Data.new("icon", "res://icon.svg", Vector2(400,200))
	pickable.visible = true
	add_child(pickable)
