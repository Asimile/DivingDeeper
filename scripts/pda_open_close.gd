extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Button.pressed.connect(on_press)
	
func on_press():
	GlobalInteractions.togglePDA.emit()
	if $Button.text == "Open PDA":
		$Button.text = "Close PDA"
	else:
		$Button.text = "Open PDA"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
