extends AnimatedSprite2D

@onready var sprite = $"."

func _process(delta: float) -> void:
	sprite.play("default")
