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

func _process(delta):
	visible = animationPlayer.is_playing()
	
func fade_in_out_black():
	animationPlayer.play("fade_in_out_black")

func fade_in_black():
	print("fade_in_black")
	if(animationPlayer.is_playing()):
		waitingAnimationType = FadeType.fade_in
		print("queued")
		return
	
	animationPlayer.play("fade_in_black")
	
func fade_out_black():
	print("fade_out_black")
	if(animationPlayer.is_playing()):
		waitingAnimationType = FadeType.fade_out
		print("queued")
		return
	
	animationPlayer.play("fade_out_black")
	
	
func _animation_finished(anim_name):
	animation_finished.emit(anim_name)
	print("animation_finished")
	if(waitingAnimationType == FadeType.fade_in):
		animationPlayer.play("fade_in_black")
		print("queued fade_int_black started")
		return
	elif(waitingAnimationType == FadeType.fade_out):
		animationPlayer.play("fade_out_black")
		print("queued fade_out_black started")
		return
		
	waitingAnimationType = FadeType.none
