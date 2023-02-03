extends Node

var currentComboCount = 0
var totalMissedBeats = 0
var totalBeats = 0

func hitTheBeat():
	currentComboCount += 1
	totalBeats += 1
	print(currentComboCount)
	
func missTheBeat():
	totalMissedBeats += 1
	currentComboCount = 0
	totalBeats += 1
	print(currentComboCount)

func _ready():
	var beatManager = get_node("/root/Node2D/BeatManager")
	beatManager.beat_grace_start.connect(_on_beat_grace_start)
	beatManager.beat_grace_end.connect(_on_beat_grace_end)
#	var missedBeatLine = get_node("/root/Node2D/MissedBeatLine")
#	missedBeatLine.body_entered.connect(_on_body_entered)
	
func _on_beat_grace_start():
	#print("_on_beat_grace_start")
	pass
	
func _on_beat_grace_end():
	#print("_on_beat_grace_end")
	pass
	
func _on_body_entered(body_rid, body, body_shape_index, local_shape_index):
	print("_on_body_entered")
	
	
