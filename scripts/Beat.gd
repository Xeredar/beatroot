extends Sprite2D

var speed : float
var inputName : String
var isActive = true
const graceRange = 20.0

@onready var playerController : CharacterBody2D = $"../../Character"

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 2
	scale = Vector2(1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta

	if isActive:
		if playerController.is_on_floor() && Input.is_action_just_pressed(inputName) && (position.x - playerController.position.x) < graceRange:
			isActive = false
			queue_free()
		if position.x <= 120:
			ComboManager.missTheBeat()
			isActive = false
			position.y += 5.0
