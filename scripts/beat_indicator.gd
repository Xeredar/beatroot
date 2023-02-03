extends Node2D

@export var start_position: Vector2
@export var bpm: int = 122
@onready var movement = create_tween().set_loops().tween_property(self, "position", Vector2(0, 0), 60.0 / bpm)

func _ready() -> void:
	movement.connect("finished", _reset)


func _reset() -> void:	position = start_position
