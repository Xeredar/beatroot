extends CanvasLayer
@onready var speech_label : Label = $MarginContainer/Panel/MarginContainer/SpeechLabel
@onready var text_box_node : MarginContainer = $MarginContainer
@onready var quest_giver : Sprite2D = $Dogquest
@onready var potato : Sprite2D = $Potato
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var speech_box : Sprite2D = $SpeechBox
var potato_speech = preload("res://sprites/text_box_p.png")
var turnip_speech = preload("res://sprites/text_box_t.png")
var potato_speech_sound = preload("res://sounds/potatoSpeech.ogg")
var turnip_speech_sound = preload("res://sounds/turnipSpeech.ogg")
var text_scrolling = false
var text = ""
var text_percentage = 0
var move_questgiver = false
var questgiver_target = Vector2(87, 130)
var potato_target = Vector2(350, 130)
var speed = 200
var texts = ["Hello there y'all! I need sum' helpin' with 'dem there beets!", "But make sure ta harvest to da beat! Don't break my tractor!", "Pawsome!"]
var current_text = 0
@onready var text_timer = $TextTimer
enum states {SLIDE_IN, DISPLAY_TEXT, WAIT}
var current_state = states.SLIDE_IN
signal intro_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	quest_giver.set_global_position(Vector2(-100, 130))
	potato.set_global_position(Vector2(570, 130))
	_hide_text()
	start()
	FadeBlack.animation_finished.connect(fade_black_animation_finished)
	
func fade_black_animation_finished(anim_name):
	if (anim_name == "fade_in_black"):
		FadeBlack.fade_out_black()
		get_tree().change_scene_to_file("res://scenes/test_konstantin.tscn")
	
func start():
	_play_scene()

func _play_scene():
	if current_state == states.WAIT:
		return
	if current_state == states.SLIDE_IN:
		_slide_in_quest_giver()
	if current_state == states.DISPLAY_TEXT and not text_scrolling:
		print("render text triggered")
		_render_text()

func _hide_text():
	speech_label.set_text("")
	text_box_node.hide()
	speech_box.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if text_scrolling:
		var percentage_visible = text_timer.time_left / (text.length() / 20.0)
		speech_label.set_visible_ratio((1 -percentage_visible))

	if move_questgiver:
		quest_giver.set_global_position(quest_giver.global_position.move_toward(questgiver_target, delta * speed))
		potato.set_global_position(potato.global_position.move_toward(potato_target, delta * speed))
		if quest_giver.global_position == questgiver_target:
			move_questgiver = false
			current_state = states.DISPLAY_TEXT
			_play_scene()
	
	if Input.is_action_just_pressed("jump") and current_state == states.WAIT:
		current_text = current_text + 1
		speech_label.set_visible_ratio(0)
		if current_text == texts.size():
			print("Dialog Finished, starting game!")
			intro_completed.emit()
			FadeBlack.fade_in_black()
		else:
			current_state = states.DISPLAY_TEXT
			_play_scene()

func _render_text():
	text_box_node.show()
	speech_box.show()
	text = texts[current_text]
	text_scrolling = true
	speech_label.set_text(text)
	text_timer.set_wait_time(text.length() / 20.0)
	text_timer.start()
	if current_text == 2:
		speech_box.set_texture(turnip_speech)
		animation_player.play("talk")
	else:
		animation_player.play("talk_potato")
	
func _slide_in_quest_giver():
	move_questgiver = true

func _on_text_timer_timeout():
	text_timer.stop()
	text_scrolling = false
	current_state = states.WAIT
	_play_scene()
	animation_player.stop()
	speech_label.set_visible_ratio(1)
	$SFX.stop()
