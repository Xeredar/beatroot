extends Node

const highscores_data_path: String = "highscores.data"

var highscores: Array

func is_new_highscore(points: int) -> bool:
	if highscores.size() == 0:
		return true
	var last_entry = highscores.back()
	return last_entry != null and points > last_entry[1]


func add_highscore_entry(name: String = "Default", highscore: int = 0) -> void:
	if name.length() > 10:
		name = name.substr(0, 10)
	highscores.append([name, highscore])
	_sort_highscores()
	if highscores.size() > 10:
		highscores.pop_back()


func save_highscores():
	var save_game = FileAccess.open(highscores_data_path, FileAccess.WRITE)
	save_game.store_var(highscores)


func _ready() -> void:
	_load_highscores()


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
