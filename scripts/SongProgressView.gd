extends Node2D

@onready var _progressBar : TextureProgressBar = $ProgressBar
@onready var _indicator : Node2D = $Bart
@onready var _beatManager : Node2D = $"../../BeatManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var l = _beatManager.songLength
	var t = l - _beatManager.timeLeft
	set_progress(t / l)

func set_progress(progress):
	_progressBar.value = progress * 100
	var w = _progressBar.size.x
	_indicator.position.x = w * (progress - 0.5)
