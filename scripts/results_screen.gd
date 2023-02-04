extends CanvasLayer
@onready var continue_label : Label = $ContinueContainer/Label
@onready var accuracy_label : Label = $ResultsContainer/Label
@onready var points_label : Label = $ResultsContainer2/Label

func _ready():
	accuracy_label.set_text("")
	points_label.set_text("")
	set_points(ComboManager.totalPoints)
	var accuracy = str((ComboManager.totalHitBeats / max((float)(ComboManager.maximumBeats), 1.0)) * 100) + "%"
	var p_accuracy = str(round(ComboManager.perfectBeats / max((float)(ComboManager.totalHitBeats), 1.0) * 100)) + "%"
	var g_accuracy = str(round(ComboManager.greatBeats / max((float)(ComboManager.totalHitBeats), 1.0) * 100)) + "%"
	set_acuracy(ComboManager.totalHitBeats, accuracy, ComboManager.perfectBeats, p_accuracy, ComboManager.greatBeats, g_accuracy)
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

func set_acuracy(hits: int, accuracy: String, p_hits: int, p_accuracy: String, g_hits: int, g_accuracy: String):
	accuracy_label.set_text("\
	Hits: {hits} ({accuracy})\n\
	PERFECT: {p_hits} ({p_accuracy})\n\
	Great: {g_hits} ({g_accuracy})"\
	.format({"hits": hits, "accuracy": accuracy, "p_hits": p_hits, "p_accuracy": p_accuracy, \
	"g_hits": g_hits, "g_accuracy": g_accuracy}))
