extends Node

var currentComboCount = 0
var totalMissedBeats = 0
var totalBeats = 0

func hitTheBeat():
	currentComboCount += 1
	totalBeats += 1
	
func missTheBeat():
	totalMissedBeats += 1
	currentComboCount = 0
	totalBeats += 1
	
