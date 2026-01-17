extends Node2D


func _on_button_pressed():
	print("Button pressed! Switching scenes")
	# Will eventually make a call to the scene manager, providing the scene to go to
	# Scene manager will handle switching scene, as well as providing the scene which items are gone or still there.
	get_tree().change_scene_to_file("res://scenes/scene_manager.tscn") #Placeholder
