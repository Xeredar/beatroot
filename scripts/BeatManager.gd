extends Node2D

signal beat_grace_start
signal beat_grace_end

var beatTextures = [load("res://sprites/beet_1.png"), load("res://sprites/carrot.png"), load("res://sprites/turnip.png")]
var obstacleObjects = [preload("res://scenes/obstacle_small.tscn")]
var suckSound1 = preload("res://sounds/Suck.ogg")
var suckSound2 = preload("res://sounds/Suck2.ogg")
var hitSound1 = preload("res://sounds/Hit1.ogg")
var jumpSound1 = preload("res://sounds/Jump1.ogg")
var suckSounds = [suckSound1, suckSound2]
var beatInputName = ["beet", "carrot", "turnip"]
var speed = 150.0
var bps = 122.0 / 60.0
const warmupTime = 3.0
const graceTime = 0.2
const graceRange = 20.0
var timeLeft = 0.0
@onready var sfx = $"../SFX"

const BeatScript = preload("res://scripts/Beat.gd")
const BeatKeyScript = preload("res://scripts/BeatKey.gd")
@onready var camera = $"../Camera"
@onready var playerController : CharacterBody2D = $"../Character"
var beats = []
var beatKeys = []
var obstacles = []
var timer = 0.0
var skipNextBeat = false
var beat_miss_indicator: PackedScene = preload("res://scenes/beat_miss_indicator.tscn")

func spawn(beatPosition):
	if randi() % 20 == 0:
		var obstacleObject = obstacleObjects[0].instantiate()
		add_child(obstacleObject)
		obstacles.push_back(obstacleObject)
		obstacleObject.position = Vector2(beatPosition + 0.5 / bps * speed, 190.0)
		skipNextBeat = true
	else:
		var beatSprite = BeatScript.new()
		var beatTypeIndex = randi() % beatTextures.size()
		var beatTexture = beatTextures[beatTypeIndex]

		beatSprite.set_texture(beatTexture)
		beats.push_back(beatSprite)
		add_child(beatSprite)
		beatSprite.position = Vector2(beatPosition, 195.0)
		beatSprite.speed = speed
		beatSprite.beatType = beatTypeIndex

		ComboManager.maximumBeats += 1

		var beatKeySprite = BeatKeyScript.new()
		var keyName = InputMap.action_get_events(beatInputName[beatTypeIndex])[0].as_text().split()[0]
		add_child(beatKeySprite)
		beatKeys.push_back(beatKeySprite)
		beatKeySprite.position = Vector2(beatPosition-10, 220.0)
		beatKeySprite.setKeyName(keyName)
		beatKeySprite.speed = speed


# Called when the node enters the scene tree for the first time.
func _ready():
	ComboManager.reset()

	var song = load("res://music/song_1_122_bpm.mp3")
	var musicPlayer = AudioStreamPlayer.new()
	add_child(musicPlayer)
	musicPlayer.set_stream(song)
	musicPlayer.play()
	timeLeft = song.get_length()

	var warmupBeatCount = floor(warmupTime * bps)
	var beatLength = song.get_length() - warmupBeatCount / bps
	for beat in range(0, beatLength * bps):
		if skipNextBeat:
			skipNextBeat = false
			continue
		if randi() % (int)(beatLength) <= beat:
			spawn(warmupBeatCount * speed + beat / bps * speed + playerController.position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeLeft -= delta
	if timeLeft < 0.0:
		get_tree().change_scene_to_file("res://scenes/results_screen.tscn")

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
	for n in beats.size():
		var beat = beats[n]
		var beatKey = beatKeys[n]
		if beat.isActive:
			if playerController.is_on_floor() && beatButtonPressed[beat.beatType] && abs(beat.position.x - playerController.position.x) < graceRange:
				ComboManager.hitTheBeat()
				didHitBeat = true
				beat.isActive = false
				beat.hide()
				beatKey.hide()
				play_sound("suck")
			if beat.position.x <= playerController.position.x - graceRange:
				ComboManager.missTheBeat()
				beat.isActive = false
				beat.position.y += 5.0
				beatKey.hide()
				camera.shake(1)

	if (pressedButtonCount == 1 && !didHitBeat) || pressedButtonCount > 1:
		ComboManager.missTheBeat()
		var miss_indicator_child: Node2D = beat_miss_indicator.instantiate()
		miss_indicator_child.position = Vector2(240, 60)
		add_child(miss_indicator_child)

	for obstacle in obstacles:
		obstacle.position.x -= speed * delta
		if obstacle.active && abs(obstacle.position.x - playerController.position.x) < 3.0 && playerController.position.y > obstacle.height:
			ComboManager.collide()
			obstacle.active = false
			camera.shake(4)
