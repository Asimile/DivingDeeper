extends Node

var fade_duration = 1.0

@onready var room_container = $RoomContainer
@onready var fade_rect := $FadeLayer/FadeRect

var current_room: Node
var is_transitioning := false

func _ready():
	# Only initialize in SceneManager
	if self.name != "SceneManager":
		return
	
	var first_room_scene := load("res://scenes/test_scene_1.tscn")
	current_room = first_room_scene.instantiate()
	room_container.add_child(current_room)

func change_room_scene(destination_path: String):
	if is_transitioning:
		return

	if not ResourceLoader.exists(destination_path):
		push_error("Room scene not found: %s" % destination_path)
		return

	is_transitioning = true
	await _fade_out()

	_swap_room(destination_path)

	await _fade_in()
	is_transitioning = false

func _fade_out():
	var tween := create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		fade_duration
	)
	await tween.finished

func _fade_in():
	var tween := create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		fade_duration
	)
	await tween.finished
	
func _swap_room(destination_path: String):
	current_room.queue_free()

	var destination_scene := load(destination_path)
	current_room = destination_scene.instantiate()
	room_container.add_child(current_room)

func _on_implosion_timer_timeout():
	#Ends the game with the sub imploding and player dying
	pass
