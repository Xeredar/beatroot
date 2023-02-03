extends CharacterBody2D

@export var jump_speed: int = -100
@export var gravity: int = 10


func _physics_process(delta) -> void:
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
