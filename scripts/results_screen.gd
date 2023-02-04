extends CanvasLayer
@onready var continue_label : Label = $ContinueContainer/Label
@onready var accuracy_label : Label = $ResultsContainer/Label
@onready var points_label : Label = $ResultsContainer2/Label

func _ready():
	accuracy_label.set_text("")
	points_label.set_text("")
	set_points(ComboManager.totalPoints)
	set_acuracy(str(round((ComboManager.totalHitBeats / max((float)(ComboManager.maximumBeats), 1.0)) * 100)) + "%")
	set_perfect_accuracy(str(round(ComboManager.perfectBeats / ComboManager.totalHitBeats as float) * 100) + "%")
	set_great_accuracy(str(round(ComboManager.greatBeats / ComboManager.totalHitBeats as float) * 100) + "%")
	$AnimationPlayer.play("blink")
	$AnimationPlayer.play("firefly")

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
	accuracy_label.set_text("Hit beats:\n{accuracy}".format({"accuracy": text}))

func set_perfect_accuracy(text):
	var prev_text = accuracy_label.get_text()
	accuracy_label.set_text(prev_text + "\n" + "PERFECT:{accuracy}".format({"accuracy": text}))

func set_great_accuracy(text):
	var prev_text = accuracy_label.get_text()
	accuracy_label.set_text(prev_text + "\n" + "Great:{accuracy}".format({"accuracy": text}))
