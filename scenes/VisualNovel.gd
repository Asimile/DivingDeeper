extends CanvasLayer

var rng = RandomNumberGenerator.new()
var haste = false
var talking = false
var currentFile = "testDialogue.txt" #file name needs to be passed in by game state manager!
var currentText = ""
var allLines
var nextIndex = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainButton.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$debugInfo.text = str($MainButton.is_disabled())

func speak(text):
	$RoboText.set_visible_characters(0)
	$RoboText.text = text
	talking = true
	for i in len(text):
		if (!haste):
			await get_tree().create_timer(.1).timeout
		else:
			await get_tree().create_timer(.03).timeout
		$RoboText.set_visible_characters(i + 1)
		if (text[i] != " "):
			var randPitch = rng.randf_range(20.0, 60.0)
			$TalkSound.set_pitch_scale(randPitch)
			$TalkSound.play()
	haste = false
	talking = false
	nextIndex += 1
	
	
func load_text_file():
	var file = FileAccess.open("res://robotDialogue/" + currentFile, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

func start_dialogue(fileName = currentFile):
	$MainButton.disabled = false
	currentFile = fileName
	currentText = load_text_file()
	var lines = currentText.split(" |")
	allLines = lines
	nextIndex = 0
	speak(allLines[nextIndex])
	
func quit_dialogue():
	#$MainButton.disabled = true
	$RoboText.text = ""
	nextIndex = -1

func _on_button_pressed() -> void:
	if nextIndex == -1:
		start_dialogue(currentFile)
	elif nextIndex < len(allLines):
		if (!talking):
			speak(allLines[nextIndex])
		else:
			haste = true
	else:
		quit_dialogue()

func _on_test_1_pressed() -> void:
	start_dialogue("testDialogue.txt")


func _on_test_2_pressed() -> void:
	start_dialogue("testDialogue2.txt")
