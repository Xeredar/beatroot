extends Label

func _ready() -> void:
	text = "Highscores\n\n" + _stringify_highscores()


func _stringify_highscores() -> String:
	var return_string = ""
	for highscore in HighScore.highscores:
		return_string += "{name}: {score}\n".format({"name": highscore[0], "score": highscore[1]})
	return return_string
