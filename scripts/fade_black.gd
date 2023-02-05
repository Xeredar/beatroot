extends CanvasLayer
signal animation_finished(anim_name)

enum FadeType {
	none,
	fade_in,
	fade_out,
}

@onready var animationPlayer = $AnimationPlayer

var waitingAnimationType: FadeType = FadeType.none

func _ready():
	animationPlayer.animation_finished.connect(_animation_finished)

func _process(_delta):
	visible = animationPlayer.is_playing()

func fade_in_out_black():
	if(!animationPlayer.is_playing()):
		animationPlayer.play("fade_in_out_black")

func fade_in_black():
	if(!animationPlayer.is_playing()):
		animationPlayer.play("fade_in_black")

func fade_out_black():
	if(!animationPlayer.is_playing()):
		animationPlayer.play("fade_out_black")


func _animation_finished(anim_name):
	animation_finished.emit(anim_name)
