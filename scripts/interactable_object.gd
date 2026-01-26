extends Node2D

@export var objectName = "toggle"
@export var texture: Resource

# override with custom logic; must emit interactionOutcomeSignal
var on_interaction : Callable

func _ready() -> void:
	$Area2D.connect("area_entered", on_area_enter)
	$Area2D.connect("area_exited", on_area_exit)
	if texture:
		$TextureRect.texture = texture

func on_area_enter(_obj):
	GlobalInteractions.connect("itemUsed", on_item_used)

func on_area_exit(_obj):
	GlobalInteractions.disconnect("itemUsed", on_item_used)

func on_item_used(idString):
	if on_interaction:
		on_interaction.call(idString)
	else:
		GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.FAIL, idString)
