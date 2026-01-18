extends Node2D

@export var objectName = "toggle"

func _ready() -> void:
	$Area2D.connect("area_entered", on_area_enter)
	$Area2D.connect("area_exited", on_area_exit)

func on_area_enter(_obj):
	GlobalInteractions.connect("itemUsed", on_item_used)

func on_area_exit(_obj):
	GlobalInteractions.disconnect("itemUsed", on_item_used)

func on_item_used(index):
	pass
	# Custom logic goes here; must emit interactionOutcomeSignal
	# GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS, index)
