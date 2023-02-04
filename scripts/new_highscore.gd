extends CanvasLayer

@onready var highscore_name_field = $Highscore_Name

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		HighScore.add_highscore_entry($Highscore_Name.get_text(), ComboManager.totalPoints)
		HighScore.save_highscores()
		get_tree().change_scene_to_file("res://scenes/results_screen.tscn")
