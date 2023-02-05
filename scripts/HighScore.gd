extends Node

const highscores_data_path: String = "highscores.data"

@onready var all_highscores: Dictionary = _load_highscores()

func is_new_highscore(level: String, points: int) -> bool:
	if not all_highscores.has(level):
		return true

	var highscores: Array = all_highscores[level]
	if highscores.size() == 0 or highscores.size() < 10:
		return true

	var last_entry = highscores.back()
	return last_entry != null and points > last_entry[1]


func add_highscore_entry(level: String, name: String = "Default", points: int = 0) -> void:
	if level.is_empty():
		level = "Debug"

	if name.length() > 10:
		name = name.substr(0, 10)

	if all_highscores.size() == 0:
		all_highscores = {level: [{"name": name, "points": points}]}
		return

	if not all_highscores.has(level):
		all_highscores[level] = [{"name": name, "points": points}]
		return

	var highscores: Array = all_highscores[level]
	highscores.append({"name": name, "points": points})
	highscores.sort_custom(_highscore_comparison)
	if highscores.size() > 10:
		highscores.pop_back()


func save_highscores():
	var save_game = FileAccess.open(highscores_data_path, FileAccess.WRITE)
	save_game.store_string(_serialize_highscores())


func _serialize_highscores() -> String:
	var return_string = ""
	var keys = all_highscores.keys()
	for key in keys:
		return_string += key + "|"
		for score in all_highscores[key]:
			return_string += "{name}:{points};".format(score)
		return_string += "<>"
	return return_string


func _deserialize_highscores(data: String) -> Dictionary:
	if data.is_empty():
		return {}

	var return_dict = {}
	var level_strings = data.split("<>", false)
	for level_string in level_strings:
		var level_data = level_string.split("|", false)
		var highscores: Array
		var highscores_strings = level_data[1].split(";", false)
		for highscore_string in highscores_strings:
			var score_string = highscore_string.split(":")
			highscores.append({"name": score_string[0], "points": score_string[1]})
		return_dict[level_data[0]] = highscores
	return return_dict


func _highscore_comparison(a, b) -> bool:
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return int(a["points"]) > int(b["points"])


func _load_highscores() -> Dictionary:
	if not FileAccess.file_exists(highscores_data_path):
		return {}

	var highscore_save = FileAccess.open(highscores_data_path, FileAccess.READ)
	return _deserialize_highscores(highscore_save.get_as_text())
