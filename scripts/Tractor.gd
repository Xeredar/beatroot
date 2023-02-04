extends Node2D

@onready var _tractor : AnimationPlayer = $TractorAnimationPlayer
@onready var _vacuum : AnimationPlayer = $VacuumAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_speed(speed):
	_tractor.speed_scale = speed

func pick_beet():
	_vacuum.play("suck")

func stop():
	_vacuum.stop()
	_tractor.stop()
