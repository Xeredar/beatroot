extends Label

var speed : float
var isActive = true

func _ready():
	z_index = 2
	scale = Vector2(1.0, 1.0)


func _process(delta):
	position.x -= speed * delta

func setKeyName(keyName: String):
	text = keyName
