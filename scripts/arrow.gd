extends Node2D

var start_position: Vector2
const end_offset: Vector2 = Vector2(20, 0)
const float_duration: float = 3.0
var tween: Tween = create_tween()
@export var destination_scene_path: String

func _ready():
	start_position = position
	
	float_between_points()

func _on_button_pressed():
	print("Button pressed! Switching scenes")
	# Will eventually make a call to the scene manager, providing the scene to go to
	# Scene manager will handle switching scene, as well as providing the scene which items are gone or still there.
	#get_tree().change_scene_to_file(destination_scene_path)
	SceneManager.change_room_scene(destination_scene_path)

func float_between_points():
	tween.set_loops() # infinite loop

	tween.tween_property(
		self,
		"position",
		start_position + end_offset,
		float_duration
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	tween.tween_property(
		self,
		"position",
		start_position,
		float_duration
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
