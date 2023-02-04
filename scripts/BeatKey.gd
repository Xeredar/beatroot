extends Label

var speed : float
var isActive = true

@onready var font = load("res://sprites/kongtext.ttf")

func _ready():
	z_index = 2
	scale = Vector2(1.0, 1.0)
	add_theme_font_override("font", font)


func _process(delta):
	position.x -= speed * delta

func setKeyName(keyName: String):
	text = keyName
