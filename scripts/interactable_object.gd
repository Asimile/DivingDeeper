extends Node2D

@export var objectName = "interactable"
@export var itemRequired = ""
@export var deleteItemAfter = false

# override with custom logic; must emit interactionOutcomeSignal
var on_interaction : Callable

func _ready() -> void:
	$Area2D.connect("area_entered", on_area_enter)
	$Area2D.connect("area_exited", on_area_exit)
	
	var texture
	var texturePath = "res://assets/sprites/"+objectName+".png"
	
	if ResourceLoader.exists(texturePath):
		texture = load(texturePath)
	else:
		texture = load("res://icon.svg")
		$Label.text = objectName
		push_warning("No sprite exists for object '"+objectName+"',")
		
	$TextureRect.texture = texture

func on_area_enter(_obj):
	GlobalInteractions.connect("itemUsed", on_item_used)

func on_area_exit(_obj):
	GlobalInteractions.disconnect("itemUsed", on_item_used)

func on_item_used(idString):
	if on_interaction:
		on_interaction.call(idString)
	else:
		if(idString == itemRequired):
			if(deleteItemAfter):
				GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS_FINAL, idString)
			else:
				GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS, idString)
		else:
			GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, idString)
