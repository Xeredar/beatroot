extends Label

var speed : float
var isActive = true

@onready var font = load("res://sprites/kongtext.ttf")
var space_sprite = preload("res://sprites/space2.png")

func _ready():
	size = Vector2(10, 10)
	z_index = 2
	scale = Vector2(1.0, 1.0)
	add_theme_font_override("font", font)
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER


func _process(delta):
	position.x -= speed * delta

func setKeyName(keyName: String):
	var finalKey = keyName
	if ComboManager.controller_enabled:
		match keyName:
			"Q":
				finalKey = "B"
			"W":
				finalKey = "X"
			"E":
				finalKey = "Y"
			
	if keyName == "␣":
		if !ComboManager.controller_enabled:
			var sprite = Sprite2D.new()
			add_child(sprite)
			sprite.set_texture(space_sprite)
			sprite.set_offset(Vector2(8, 10))
		else:
			finalKey = "A"
			text = finalKey
	else:
		text = finalKey
