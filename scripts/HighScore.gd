extends Node

const highscores_data_path: String = "highscores.data"

var all_highscores: Dictionary = {}#_load_highscores()

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

	add_highscore_entry_server(level, name, points)

#	if all_highscores.size() == 0:
#		all_highscores = {level: [{"name": name, "points": points}]}
#		return

#	if not all_highscores.has(level):
#		all_highscores[level] = [{"name": name, "points": points}]
#		return

#	var highscores: Array = all_highscores[level]
#	highscores.append({"name": name, "points": points})
#	highscores.sort_custom(_highscore_comparison)
#	if highscores.size() > 10:
#		highscores.pop_back()


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

func _ready():
	_load_all_highscores_server()

func _load_all_highscores_server():
	all_highscores = {}
	_load_highscore_server("Debug")
	_load_highscore_server("song_1")
	_load_highscore_server("song_2")
	_load_highscore_server("song_3")
	_load_highscore_server("song_4")
	_load_highscore_server("song_5")


func add_highscore_entry_server(level: String, name: String = "Default", points: int = 0) -> void:
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)

	# Perform a GET request. The URL below returns JSON as of writing.
	var requestURL = "https://api.slin.dev/beatroot/v1/add?scene={level}&name={name}&points={points}".format({"level": level, "name": name.strip_edges(), "points": points})
	print(requestURL)
	var error = http_request.request(requestURL)
	if error != OK:
		push_warning("An error occurred in the HTTP request.")

	var highscores: Array = all_highscores[level]
	highscores.append({"name": name, "points": points})
	highscores.sort_custom(_highscore_comparison)
	if highscores.size() > 10:
		highscores.pop_back()

func _load_highscore_server(scene):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", _server_list_response)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request("https://api.slin.dev/beatroot/v1/list?scene=" + scene)
	if error != OK:
		push_warning("An error occurred in the HTTP request.")


func _server_list_response(result, response_code, headers, body):
	var json = JSON.new()
	var response = json.parse_string(body.get_string_from_utf8())
	all_highscores[response["scene"]] = []
	for entry in response["list"]:
		all_highscores[response["scene"]].push_back(entry["metadata"])
	print(all_highscores)
