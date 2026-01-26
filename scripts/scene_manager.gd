extends Node

@onready var room_container = $RoomContainer
@onready var animation_player = $AnimationPlayer

@onready var footsteps_sfx = $Audio/Footsteps
@onready var pre_implosion_sfx = $Audio/PreImplosion
@onready var implosion_sfx = $Audio/Implosion
@onready var ambient_sfx = $Audio/Ambient

@onready var implosion_timer = $ImplosionTimer

var current_room: Node
var is_transitioning := false

var currentItem: Node

var InventoryItemData = preload("res://scripts/item_data.gd")
var InventoryItem = preload("res://scenes/inventory_item.tscn")

func _ready():
	# Only initialize in SceneManager
	if self.name != "SceneManager":
		return
	
	# Generate whatever our very first scene will be when launching the game, and make it the current room
	var first_room_scene := load("res://scenes/test_scene_1.tscn")
	current_room = first_room_scene.instantiate()
	room_container.add_child(current_room)
	
	#handle inventory item selection
	GlobalInteractions.itemSelected.connect(on_inventory_item_selected)
	
	#handle opening/closing of PDA
	GlobalInteractions.togglePDA.connect(toggle_pda)
	implosion_timer.start()

func change_room_scene(destination_path: String):
	#After an arrow has been pressed, can't really activate another until transition is done
	if is_transitioning:
		return
	
	# If the room we route to doesn't exist, avoid crashing and just do nothing
	if not ResourceLoader.exists(destination_path):
		push_error("Room scene not found: %s" % destination_path)
		return
		
	is_transitioning = true
	fade_and_swap(destination_path)
	is_transitioning = false
	
func fade_and_swap(destination_path: String):
	# Trigger the animation to bring the FadeRect's opacity up and down
	animation_player.play("fade")
	#Players footstep sound effects with a slightly randomized pitch to keep them fresh
	if (true): # Will need to be replaced with "if (current_room != main menu)" So that footsteps only happen when it makes sense
		footsteps_sfx.pitch_scale = randf_range(0.8, 1.2)
		footsteps_sfx.play()
	#Pauses this function until the animation player emits the finished signal
	await animation_player.animation_finished
	
	_swap_room(destination_path)
	
	animation_player.play_backwards()

func _swap_room(destination_path: String):
	# Whatever scene is assigned as current_room gets deleted
	current_room.queue_free()
	
	# The scene provided by the arrow we clicked is loaded, and assigned to current_room under RoomContainer
	var destination_scene := load(destination_path)
	current_room = destination_scene.instantiate()
	room_container.add_child(current_room)

func on_inventory_item_selected(itemID):
	if currentItem == null || not currentItem.data.itemID == itemID:
		var itemData = InventoryItemData.new(itemID)
		currentItem = InventoryItem.instantiate()
		currentItem.data = itemData
		currentItem.visible = true
		add_child(currentItem)
		
func toggle_pda():
	GlobalData.pda_open = not GlobalData.pda_open
	$Pda.visible = GlobalData.pda_open
	print("PDA is visible ="+ str(GlobalData.pda_open))

func _on_implosion_timer_timeout():
	#Ends the game with the sub imploding and player dying
	if animation_player.is_playing():
		await animation_player.animation_finished
	animation_player.play("implosion")
	await animation_player.animation_finished
	get_tree().quit()
