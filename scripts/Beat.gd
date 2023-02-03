extends Sprite2D

var speed : float
var key : int

var _isHit = false
var is_grace = false
var playerPosition = Vector2(144, 96)

#@onready var beatManager = $"/root/Node2D/BeatManager"
var beatManager: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	beatManager = get_parent()
	z_index = 2
	scale = Vector2(1.0, 1.0)
	beatManager.connect("beat_grace_start", _set_grace_true)
	beatManager.connect("beat_grace_end", _set_grace_false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
	
	if(position.x <= 0):
		ComboManager.missTheBeat()
		queue_free()
		
	if Input.is_key_pressed(key):
		var distance = position.distance_to(playerPosition)
		if(!_isHit && is_grace && distance <= 75):
			_isHit = true
			ComboManager.hitTheBeat()
			print("hit the beat" + str(distance))

func _set_grace_true() -> void:
	is_grace = true

func _set_grace_false() -> void:
	is_grace = false
