extends Node2D

@export var bpm: int = 122
@export var indicator_x_offset: float = 100
@export var rigt_target_scale = 0.632

@onready var center_indicator : Node2D = $"Center Indicator"
@onready var left_indicator : Node2D = $"Left Indicator"
@onready var right_indicator : Node2D = $"Right Indicator"

func _ready() -> void:
	var duration = 60.0 / bpm
	
	var tween = create_tween().set_loops().set_parallel().set_ease(Tween.EASE_IN)
	tween.loop_finished.connect(_on_finished)
	
	tween.tween_property(left_indicator, "position", Vector2(0, 0), duration)
	tween.tween_property(right_indicator, "position", Vector2(0, 0), duration)
	tween.tween_property(center_indicator, "scale", Vector2(rigt_target_scale, rigt_target_scale), duration)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), duration * 0.3)
	_reset()

func _on_finished(loop):
	_reset()

func _reset():
	modulate = Color(1, 1, 1, 0);
	center_indicator.scale = Vector2(1, 1);
	left_indicator.position.x = -indicator_x_offset;
	right_indicator.position.x = indicator_x_offset;
