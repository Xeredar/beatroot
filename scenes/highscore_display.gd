extends CanvasLayer


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
