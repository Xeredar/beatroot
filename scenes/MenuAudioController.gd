extends AudioStreamPlayer

var menu_music

func _ready() -> void:
	menu_music = load("res://music/2. Bim Bom Bomp.mp3")
	stream = menu_music
	play()


func play_music():
	if not playing:
		play()


func stop_music():
	stop()
