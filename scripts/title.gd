extends CanvasLayer

func _ready():
	$AnimationPlayer.play("Pulse")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/intro.tscn")

