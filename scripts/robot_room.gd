extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RobotSprite/InteractableItemHitbox.on_interaction = eatItAll

func eatItAll(idString):
	GlobalData.itemsCollected[idString] = true
	GlobalInteractions.emit_signal("interactionOutcome", GlobalInteractions.OUTCOME.SUCCESS_FINAL, idString)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	var win = true
	
	for item in GlobalData.itemsCollected:
		if GlobalData.itemsCollected[item] == false:
			win = false
			break
			
	if win:
		GlobalData.emit_signal("youWin")
