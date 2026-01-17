extends Node

var fade_duration = 1.0

@onready var room_container = $RoomContainer
@onready var fade_rect := $FadeRect
@onready var animation_player = $AnimationPlayer

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
	fade_and_swap(destination_path)
	is_transitioning = false
	
func fade_and_swap(destination_path: String):
	animation_player.play("fade")
	await animation_player.animation_finished
	
	_swap_room(destination_path)
	
	animation_player.play_backwards()

func _swap_room(destination_path: String):
	current_room.queue_free()

	var destination_scene := load(destination_path)
	current_room = destination_scene.instantiate()
	room_container.add_child(current_room)

func _on_implosion_timer_timeout():
	#Ends the game with the sub imploding and player dying
	pass
