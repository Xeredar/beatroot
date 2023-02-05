extends CanvasLayer

@onready var song1_button : Button = $MarginContainer/ScrollContainer/VBoxContainer/Panel/Song1Button
@onready var song2_button : Button = $MarginContainer/ScrollContainer/VBoxContainer/Panel2/Song2Button
@onready var song3_button : Button = $MarginContainer/ScrollContainer/VBoxContainer/Panel3/Song3Button
@onready var song4_button : Button = $MarginContainer/ScrollContainer/VBoxContainer/Panel4/Song4Button
@onready var song5_button : Button = $MarginContainer/ScrollContainer/VBoxContainer/Panel5/Song5Button
@onready var song1_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Panel/Song1
@onready var song2_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Panel2/Song2
@onready var song3_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Panel3/Song3
@onready var song4_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Panel4/Song4
@onready var song5_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Panel5/Song5
@onready var sound_button : Sprite2D = $KonstantineToggle
@onready var play_button : Button = $PlayButton
@onready var artists_display : Label = $MarginContainer2/Panel/Artist/Label
@onready var title_display : Label = $MarginContainer2/Panel/TitleAndDifficutly/Label
@onready var first_time = true
var konstantin_off = preload("res://sprites/soundOff.png")
var konstantin_on = preload("res://sprites/soundOn.png")
var sound_enabled = true

var allSongTitles = []
var allSongArtists = []
var allDifficultis = []
var allSongLabels = []
var selected_song = 0
var allSongScenes = ["song_1", "song_2", "song_3", "song_4", "song_5"]

func _ready():
	allSongTitles = ["Feathers and Pillow", "Silhoutte Pt. II", "Night Rave", "None Of It", "Knife Crayons"]
	allSongArtists = ["Sara Afonso", "whatfunk", "Jason Shaw", "whatfunk", "Gigakoops"]
	allDifficultis = [0, 1, 1, 1, 2]
	allSongLabels = [song1_label, song2_label, song3_label, song4_label, song5_label]
	fill_songlist()
	fill_details()

func _process(delta):
	if first_time:
		first_time = false
		return
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/" + allSongScenes[selected_song] + ".tscn")
	if Input.is_action_just_pressed("down"):
		print("Down Pressed!")
		if selected_song < allSongTitles.size() - 1:
			allSongLabels[selected_song].get_parent().get_child(2).hide()
			selected_song = selected_song + 1
			fill_details()
	if Input.is_action_just_pressed("up"):
		if selected_song > 0:
			allSongLabels[selected_song].get_parent().get_child(2).hide()
			selected_song = selected_song - 1
			fill_details()

func fill_songlist():
	for song in allSongTitles.size():
		allSongLabels[song].set_text(allSongTitles[song])

func fill_details():
	var _difficulty = ""
	match allDifficultis[selected_song]:
		0:
			_difficulty = "Easy"
		1:
			_difficulty = "Medium"
		2:
			_difficulty = "Hard"
	artists_display.set_text("Artist: " + "\n" + allSongArtists[selected_song])
	title_display.set_text(allSongTitles[selected_song] + "\n" + _difficulty)
	allSongLabels[selected_song].get_parent().get_child(2).show()

func _on_song_1_button_pressed():
	allSongLabels[selected_song].get_parent().get_child(2).hide()
	selected_song = 0
	fill_details()

func _on_song_2_button_pressed():
	allSongLabels[selected_song].get_parent().get_child(2).hide()
	selected_song = 1
	fill_details()

func _on_song_3_button_pressed():
	allSongLabels[selected_song].get_parent().get_child(2).hide()
	selected_song = 2
	fill_details()

func _on_song_4_button_button_down():
	allSongLabels[selected_song].get_parent().get_child(2).hide()
	selected_song = 3
	fill_details()

func _on_song_5_button_pressed():
	allSongLabels[selected_song].get_parent().get_child(2).hide()
	selected_song = 4
	fill_details()

func _on_play_button_pressed():
	print("Loading Song: " + str(selected_song))
	ComboManager.currentLevel = allSongScenes[selected_song]
	get_tree().change_scene_to_file("res://scenes/" + ComboManager.currentLevel + ".tscn")

func _on_button_pressed():
	sound_enabled = !sound_enabled
	if sound_enabled:
		sound_button.set_texture(konstantin_on)
		ComboManager.konstantinToggle = false
		print("Sound Effects enabled!")
	else:
		sound_button.set_texture(konstantin_off)
		ComboManager.konstantinToggle = true
		print("Sound Effects disabled!")
