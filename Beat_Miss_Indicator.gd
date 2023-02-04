extends Sprite2D

func _ready() -> void:
	var animation_player = $AnimationPlayer
	animation_player.play("fade")
	animation_player.connect("animation_finished", func(_x): queue_free)
