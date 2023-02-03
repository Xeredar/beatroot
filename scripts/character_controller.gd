extends CharacterBody2D

@export var jump_speed: int = -400
@export var gravity: int = 1000
@export var extra_jumps: int = 2

var current_jumps: int = 0

func _physics_process(delta) -> void:
	velocity.y += gravity * delta

	move_and_slide()

	if is_on_floor():
		current_jumps = 0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
		elif current_jumps < extra_jumps:
			velocity.y = jump_speed
			current_jumps += 1
