extends Label

func show_evaluation(text_to_display: String) -> void:
	text = text_to_display
	var animation_player = $AnimationPlayer
	animation_player.play("move_up")
	animation_player.connect("animation_finished", func(_x): queue_free())
