extends Node2D

signal beat_grace_start
signal beat_grace_end

@export var songResourceName = "res://music/song_1_122_bpm_short.mp3"
@export var songBPM = 122.0
@export var graceTime = 0.2
@export var graceRange = 20.0

var beatTextures = [load("res://sprites/beet_1.png"), load("res://sprites/carrot.png"), load("res://sprites/turnip.png")]
var obstacleObjects = [preload("res://scenes/obstacle_small.tscn"), preload("res://scenes/obstacle_big.tscn")]
var suckSound1 = preload("res://sounds/Suck.ogg")
var suckSound2 = preload("res://sounds/Suck2.ogg")
var suckSounds = [suckSound1, suckSound2]
var hitSound1 = preload("res://sounds/Hit1.ogg")
var hitSound2 = preload("res://sounds/Hit2.ogg")
var hitSounds = [hitSound1, hitSound2]
var jumpSound1 = preload("res://sounds/Jump1.ogg")
var jumpSound2 = preload("res://sounds/Jump2.ogg")
var jumpSounds = [jumpSound1, jumpSound2]
var beatInputName = ["beet", "carrot", "turnip"]
var speed = 150.0
var bps = 122.0 / 60.0
const warmupTime = 3.0
const perfect_distance = 0.1
const great_distance = 0.5
var timeLeft = 0.0
@onready var sfx = $"../SFX"

const BeatScript = preload("res://scripts/Beat.gd")
const BeatKeyScript = preload("res://scripts/BeatKey.gd")
@onready var camera = $"../Camera"
@onready var tractor = $"../Tractor"
@onready var playerController : CharacterBody2D = $"../Character"
var beats = []
var beatKeys = []
var obstacles = []
var timer = 0.0
var wantsBigObstacle = false
var skipNextBeat = false
var beat_miss_indicator: PackedScene = preload("res://scenes/beat_miss_indicator.tscn")
var beat_hit_evaluation: PackedScene = preload("res://scenes/hit_evaluation_texts.tscn")

func _spawnBeat(beatPosition):
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

func _spawnSmallObstacle(beatPosition):
	var obstacleObject = obstacleObjects[0].instantiate()
	obstacleObject.position = Vector2(beatPosition + 0.5 / bps * speed, 190.0)
	add_child(obstacleObject)
	obstacles.push_back(obstacleObject)
	skipNextBeat = true

func _spawnBigObstacle(beatPosition):
	var obstacleObject = obstacleObjects[1].instantiate()
	obstacleObject.position = Vector2(beatPosition + 0.5 / bps * speed, 170.0)
	add_child(obstacleObject)
	obstacles.push_back(obstacleObject)
	skipNextBeat = true


# Called when the node enters the scene tree for the first time.
func _ready():
	ComboManager.reset()
	bps = songBPM / 60.0

	var song = load(songResourceName)
	var musicPlayer = AudioStreamPlayer.new()
	add_child(musicPlayer)
	musicPlayer.set_stream(song)
	musicPlayer.play()
	timeLeft = song.get_length() + 3.0

	var warmupBeatCount = floor(warmupTime * bps)
	var beatLength = song.get_length() - warmupBeatCount / bps
	var beatOffset = warmupBeatCount / bps * speed + playerController.position.x
	for beat in range(0, beatLength * bps + 1):
		var beatPosition = beatOffset + beat / bps * speed
		if skipNextBeat:
			skipNextBeat = false
			continue
		if wantsBigObstacle:
			_spawnBigObstacle(beatPosition)
			wantsBigObstacle = false
			continue
		if randi() % (int)(beatLength) <= 1000:#beat:
			if randi() % 20 == 0:
				if randi() % 3 == 0:
					wantsBigObstacle = true
				else:
					_spawnSmallObstacle(beatPosition)
			else:
				_spawnBeat(beatPosition)

	FadeBlack.animation_finished.connect(fade_black_animation_finished)

func fade_black_animation_finished(anim_name):
	if (anim_name == "fade_in_black"):
		FadeBlack.animation_finished.disconnect(fade_black_animation_finished)
		FadeBlack.fade_out_black()
		get_tree().change_scene_to_file("res://scenes/results_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timeLeft > 0.0:
		timeLeft -= delta

	if timeLeft < 0.0:
		timeLeft = 0
#		get_tree().change_scene_to_file("res://scenes/results_screen.tscn")
		FadeBlack.fade_in_black()

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
			var distance: float = abs(beat.position.x - playerController.position.x)
			if playerController.is_on_floor() && beatButtonPressed[beat.beatType] && distance < graceRange:
				ComboManager.hitTheBeat()
				tractor.pick_beet()
				var hit_evaluation = beat_hit_evaluation.instantiate()
				var evaluation_string = "Good"
				if distance / graceRange < perfect_distance:
					evaluation_string = "PERFECT!"
					ComboManager.hitPerfectBeat()
				elif distance < great_distance:
					evaluation_string = "Great!"
					ComboManager.hitGreatBeat()
				hit_evaluation.show_evaluation(evaluation_string)
				add_child(hit_evaluation)
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

func play_sound(sound):
	match (sound):
		"suck":
			sfx.stream = suckSounds[randi() % suckSounds.size()]
			sfx.set_volume_db(-8)
		"hit":
			sfx.stream = hitSounds[randi() % hitSounds.size()]
			sfx.set_volume_db(-8)
		"jump":
			sfx.stream = jumpSounds[randi() % jumpSounds.size()]
			sfx.set_volume_db(-8)
	sfx.play()
