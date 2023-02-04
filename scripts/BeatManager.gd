extends Node2D

signal beat_grace_start
signal beat_grace_end

var beatTextures = [load("res://sprites/beet_1.png"), load("res://sprites/carrot.png"), load("res://sprites/turnip.png")]
var beatInputName = ["beet", "carrot", "turnip"]
var speed = 150.0
var bps = 122.0 / 60.0
const warmupTime = 3.0
const graceTime = 0.15
const graceRange = 20.0

const BeatScript = preload("res://scripts/Beat.gd")
@onready var playerController : CharacterBody2D = $"../Character"
var beats = []
var timer = 0.0


func spawn(beatPosition):
	var beatSprite = BeatScript.new()
	var beatTypeIndex = randi() % beatTextures.size()
	var beatTexture = beatTextures[beatTypeIndex]
	beatSprite.set_texture(beatTexture)
	beats.push_back(beatSprite)
	add_child(beatSprite)
	var windowSize = get_viewport().size
	beatSprite.position = Vector2(beatPosition, 195.0)
	beatSprite.speed = speed
	beatSprite.beatType = beatTypeIndex


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
		if randi() % (int)(beatLength) <= beat:
			spawn(warmupBeatCount * speed + beat / bps * speed + playerController.position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 1.0/bps - graceTime * 0.5:
		beat_grace_start.emit()
	if timer > 1.0/bps + graceTime * 0.5:
		beat_grace_end.emit()
		timer -= 1.0/bps

	var beatButtonPressed = []
	var pressedButtonCount = 0
	for beatButton in beatInputName:
		var isPressed = Input.is_action_just_pressed(beatButton)
		beatButtonPressed.push_back(isPressed)
		if isPressed:
			pressedButtonCount += 1

	var didHitBeat = false
	for beat in beats:
		if beat.isActive:
			if playerController.is_on_floor() && beatButtonPressed[beat.beatType] && abs(beat.position.x - playerController.position.x) < graceRange:
				ComboManager.hitTheBeat()
				didHitBeat = true
				beat.isActive = false
				beat.hide()
			if beat.position.x <= playerController.position.x - graceRange:
				ComboManager.missTheBeat()
				beat.isActive = false
				beat.position.y += 5.0

	if (pressedButtonCount == 1 && !didHitBeat) || pressedButtonCount > 1:
		ComboManager.missTheBeat()
