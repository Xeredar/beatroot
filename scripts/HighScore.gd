extends Node

const highscores_data_path: String = "highscores.data"

var highscores: Array

func add_highscore_entry(name: String, highscore: int) -> void:
	highscores.append([name, highscore])
	_sort_highscores()
	if highscores.size() > 10:
		highscores.pop_back()


func save_highscores():
	var save_game = FileAccess.open(highscores_data_path, FileAccess.WRITE)
	save_game.store_var(highscores)


func _ready() -> void:
	_load_highscores()
	print(highscores)


func _sort_highscores() -> void:
	highscores.sort_custom(_highscore_comparison)


func _highscore_comparison(a, b) -> bool:
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a[1] > b[1]


func _load_highscores():
	if not FileAccess.file_exists(highscores_data_path):
		highscores = []
		return

	var highscore_save = FileAccess.open(highscores_data_path, FileAccess.READ)
	highscores = highscore_save.get_var()
