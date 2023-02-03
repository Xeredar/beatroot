extends CharacterBody2D

@export var jump_speed: int = -400
@export var gravity: int = 1000
@export var extra_jumps: int = 1

@onready var beatmanager = $"../BeatManager"

var current_jumps: int = 0
var is_grace: bool = false

func _ready() -> void:
	if beatmanager != null:
		print("BeatManager found")
		beatmanager.connect("beat_grace_start", _set_grace_true)
		beatmanager.connect("beat_grace_end", _set_grace_false)


func _physics_process(delta) -> void:
	velocity.y += gravity * delta

	move_and_slide()

	if is_on_floor():
		current_jumps = 0


	if Input.is_action_just_pressed("jump"):
		if is_grace:
			if is_on_floor():
				velocity.y = jump_speed
			elif current_jumps < extra_jumps:
				velocity.y = jump_speed
				current_jumps += 1
		else:
			current_jumps += 1


func _set_grace_true() -> void:
	is_grace = true


func _set_grace_false() -> void:
	is_grace = false
