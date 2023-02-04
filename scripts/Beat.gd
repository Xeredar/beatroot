extends Sprite2D

var speed : float
var beatType : int

var isActive = true

@onready var playerController : CharacterBody2D = $"../../LevelContent/Character"

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 2
	scale = Vector2(1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta

