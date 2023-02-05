extends Sprite2D

var speed : float
var beatType : int
var beet_particles: PackedScene = preload("res://scenes/beet.tscn")
var isActive = true
var particles

@onready var playerController : CharacterBody2D = $"../../LevelContent/Character"

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 2
	scale = Vector2(1.0, 1.0)
	particles = beet_particles.instantiate()
	add_child(particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta

func emit():
	particles.emit_dirt()
