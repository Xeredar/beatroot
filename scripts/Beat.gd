extends Sprite2D

var speed : float

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
