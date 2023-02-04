extends Node2D

@onready var _label : Label = $Label
@onready var _shine : Node2D = $MultiplierBgShine
@onready var _shine2 : Node2D = $MultiplierBgShine2
@onready var _animationPlayer : AnimationPlayer = $AnimationPlayer

var _previousMultiplier : int = 1


func _ready():
	_animate_shine(_shine, 1, 1, 0.85, 6, 2)
	_animate_shine(_shine2, -1, 0.87, 0.98, 8, 2.5)
	_shine.hide()
	_shine2.hide()
	

func _animate_shine(shine, direction, scaleA, scaleB, rotation_duration, fade_duration):
	var rotation_tween = create_tween().set_loops()
	rotation_tween.tween_property(shine, "rotation_degrees", 0, 0)
	rotation_tween.tween_property(shine, "rotation_degrees", direction * 360, rotation_duration)
	
	var scale_tween = create_tween().set_loops()
	scale_tween.tween_property(shine, "scale", Vector2(scaleA, scaleA), fade_duration)
	var c1 = shine.modulate
	var c2 = Color(c1.r, c1.g, c1.b, 0.2)
	scale_tween.parallel().tween_property(shine, "modulate", c2, fade_duration)
	scale_tween.tween_property(shine, "scale", Vector2(scaleB, scaleB), fade_duration)
	scale_tween.parallel().tween_property(shine, "modulate", c1, fade_duration)


func _process(_delta):
	var newMultiplier = ComboManager.currentMultiplier
	
	if (newMultiplier == _previousMultiplier):
		return
		
	_label.text = "{multiplier}x".format({"multiplier": ComboManager.currentMultiplier})
	
	if newMultiplier < _previousMultiplier:
		_animationPlayer.play("decrease")
	else:
		_animationPlayer.play("increase")
		
	if newMultiplier >= 8:
		_shine.show()
		_shine2.show()
	else:
		_shine.hide()
		_shine2.hide()
	
	_previousMultiplier = newMultiplier

