extends CanvasLayer

func _ready():
	$AnimationPlayer.play("Pulse")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _unhandled_input(event):
	if event is InputEventJoypadButton:
		if event.pressed and Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			ComboManager.controller_enabled = true
	elif event is InputEventMouseButton:
		if event.pressed and Input.is_key_pressed(KEY_SPACE):
			ComboManager.controller_enabled = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
