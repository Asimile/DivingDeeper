extends AnimatedSprite2D

@onready var sprite = $"."

func _process(_delta) -> void:
	sprite.play("default")
