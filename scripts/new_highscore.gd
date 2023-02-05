extends CanvasLayer

@onready var highscore_name_field = $Highscore_Name
@onready var label = $Label2

func _ready() -> void:
	MenuAudio.play_music()
	highscore_name_field.grab_focus()
	if ComboManager.controller_enabled:
		label.set_text("Press A to confirm")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		HighScore.add_highscore_entry(ComboManager.currentLevel, $Highscore_Name.get_text(), ComboManager.totalPoints)
		HighScore.save_highscores()
		get_tree().change_scene_to_file("res://scenes/results_screen.tscn")
