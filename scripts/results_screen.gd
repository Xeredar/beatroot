extends CanvasLayer
@onready var continue_label : Label = $ContinueContainer/Label
@onready var accuracy_label : Label = $ResultsContainer/Label
@onready var points_label : Label = $ResultsContainer2/Label

func _ready():
	accuracy_label.set_text("")
	points_label.set_text("")
	set_points(ComboManager.totalPoints)
	set_acuracy(str((ComboManager.totalHitBeats / max(ComboManager.maximumBeats, 1)) * 100) + "%")
	$AnimationPlayer.play("blink")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		print("Replay triggered!")
		get_tree().change_scene_to_file("res://scenes/test_konstantin.tscn")
	if Input.is_action_just_pressed("turnip"):
		print("Next Level triggered!")
		get_tree().change_scene_to_file("res://scenes/test_konstantin.tscn")

func set_points(text):
	points_label.set_text("Points:\n{points}".format({"points": text}))

func set_acuracy(text):
	accuracy_label.set_text("Accuracy:\n{accuracy}".format({"accuracy": text}))
