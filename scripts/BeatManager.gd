extends Node2D

signal beat_grace_start
signal beat_grace_end

var beatTextures = [load("res://sprites/beet_1.png"), load("res://sprites/carrot.png"), load("res://sprites/turnip.png")]
var speed = 150.0
var bps = 122.0 / 60.0
var warmupTime = 3.0
var graceTime = 0.1

const BeatScript = preload("res://scripts/Beat.gd")
var beats = []
var timer = 0.0


func spawn(position):
	var beatSprite = BeatScript.new()
	var beatTexture = beatTextures[randi() % beatTextures.size()]
	beatSprite.set_texture(beatTexture)
	beats.push_back(beatSprite)
	add_child(beatSprite)
	var windowSize = get_viewport().size
	beatSprite.position = Vector2(position, windowSize.y * 0.5)
	beatSprite.speed = speed


# Called when the node enters the scene tree for the first time.
func _ready():
	var song = load("res://music/song_1_122_bpm.mp3")
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.set_stream(song)
	player.play()

	var warmupBeatCount = floor(warmupTime * bps)
	var beatLength = song.get_length() - warmupBeatCount / bps
	for beat in range(0, beatLength * bps):
		spawn(warmupBeatCount * speed + beat / bps * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 1.0/bps - graceTime * 0.5:
		beat_grace_start.emit()
	if timer > 1.0/bps + graceTime * 0.5:
		beat_grace_end.emit()
		timer -= 1.0/bps

