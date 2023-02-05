extends CharacterBody2D

@export var jump_speed: int = -325
@export var gravity: int = 1000
@export var extra_jumps: int = 1

@onready var beatmanager = $"../../BeatManager"

signal victory_animation_done
var current_jumps: int = 0
var is_grace: bool = false
var game_ended = false

func _ready() -> void:
	$VictoryAnimatedSprite.stop()
	if beatmanager != null:
		beatmanager.connect("beat_grace_start", _set_grace_true)
		beatmanager.connect("beat_grace_end", _set_grace_false)
		game_ended = false


func _physics_process(delta) -> void:
	velocity.y += gravity * delta
	move_and_slide()

	if is_on_floor():
		current_jumps = 0

	if Input.is_action_just_pressed("jump"):
		if game_ended:
			return
		if is_grace:
			if is_on_floor():
				beatmanager.play_sound("jump")
				velocity.y = jump_speed
			elif current_jumps < extra_jumps:
				beatmanager.play_sound("jump")
				velocity.y = jump_speed
				current_jumps += 1
		else:
			current_jumps += 1


func _set_grace_true() -> void:
	is_grace = true


func _set_grace_false() -> void:
	is_grace = false
	
func end_animation():
	game_ended = true
	$AnimatedSprite2D.hide()
	$VictoryAnimatedSprite.show()
	$VictoryAnimatedSprite.play("default")
	$AnimationPlayer.play("stopping")

func _on_victory_animated_sprite_animation_finished():
	$VictoryAnimatedSprite.stop()
	$VictoryAnimatedSprite.set_frame_and_progress(19, 0.0)
	victory_animation_done.emit()
