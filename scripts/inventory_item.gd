extends Node2D

var dragging = false
var xoff = 0
var yoff = 0

signal dragSignal
signal dropSignal

func _ready():
	$Button.button_down.connect(_emit_drag)
	$Button.button_up.connect(_emit_drop)

func _emit_drag():
	emit_signal("dragSignal")
	dragging = true
	xoff = self.position.x - get_viewport().get_mouse_position().x
	yoff = self.position.y - get_viewport().get_mouse_position().y
	print("dragging")

func _emit_drop():
	emit_signal("dropSignal")
	dragging = false
	print("dropped")

func _process(_delta):
	if dragging:
		self.position.x = xoff + get_viewport().get_mouse_position().x
		self.position.y = yoff + get_viewport().get_mouse_position().y

#func _on_characterBody2d_input_event (_viewport, event, _shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#emit_signal("dragsignal")
		#elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			#emit_signal("dragsignal")
	#elif event is InputEventScreenTouch:
		#if event.pressed and event.get_index() == 0:
			#self.position = event.get_position()
