extends Label

func _ready() -> void:
	text = _stringify_highscores()


func _stringify_highscores() -> String:
	var return_string = ""
	var index = 1
	print(HighScore.all_highscores[ComboManager.currentLevel])
	for highscore in HighScore.all_highscores[ComboManager.currentLevel]:
		return_string += str(index) + ". {name}: {points}\n".format(highscore)
		index += 1
	return return_string
