#extends Camera2D
#
#@onready var shakeTimer = $Timer
#var tween: Tween
#
#var shake_amount = 0
#var default_offset = offset
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	set_process(false)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(shake_amount, -shake_amount)) * delta + default_offset
#
#
#func shake(new_shake, shake_time, shake_limit):
#	shake_amount += new_shake
#	if shake_amount > shake_limit:
#		shake_amount = shake_limit
#
#	shakeTimer.wait_time = shake_time
#
##	tween.stop_all()
#
#	set_process(true)
#	shakeTimer.start()
#
#func _on_timer_timeout():
#	shake_amount = 0
#	set_process(false)
#	tween.interpolate_value(offset, default_offset - offset, 0.1, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

extends Camera2D


@export var shake_range = 0.5
@export var zoom_range = 0.0005
@export var shake_power = 4
@export var shake_time = 0.1
var isShake = false
var default_offset
var default_zoom
var elapsedtime = 0

func _ready():
	randomize()
	default_offset = offset
	default_zoom = zoom

func _process(delta):
	if isShake:
		_shake_screen(delta)    

func shake(power = 4):
	elapsedtime = 0
	isShake = true
	shake_power = power

func _shake_screen(delta):
	if elapsedtime<shake_time:
		offset +=  Vector2(randf_range(-shake_range, shake_range), randf_range(-shake_range, shake_range)) * shake_power
		zoom +=  Vector2(randf_range(zoom_range, zoom_range * 2), randf_range(zoom_range, zoom_range*2)) * shake_power
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		offset = default_offset
		zoom = default_zoom 
