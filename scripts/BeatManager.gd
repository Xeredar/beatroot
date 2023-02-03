extends Node

var beatTextures = [load("res://sprites/icon.svg")]

const BeatScript = preload("res://scripts/Beat.gd")
var beats = []
var speed = 122.0

func spawn(time):
	var beatSprite = BeatScript.new() # Create a new Sprite2D.
	var beatTexture = beatTextures[randi() % beatTextures.size()]
	beatSprite.set_texture(beatTexture)
	beats.push_back(beatSprite)
	add_child(beatSprite)
	var windowSize = get_viewport().size
	beatSprite.position = Vector2(time, windowSize.y * 0.5)
	beatSprite.speed = speed
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for time in range(2, 40):
		spawn(time * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
