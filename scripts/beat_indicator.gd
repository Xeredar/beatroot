extends Node2D

@export var start_position: Vector2
@export var bpm: int = 122

func _ready() -> void:
	var movement = create_tween().set_loops().tween_property(self, "position", Vector2(0, 0), 60.0 / bpm)
	movement.connect("finished", func(): position = start_position)
