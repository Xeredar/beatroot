extends Node

var currentComboCount = 0
var currentMultiplier = 1
var totalMissedBeats = 0
var totalHitBeats = 0
var totalPoints = 0
var maximumBeats = 0

func hitTheBeat():
	currentComboCount += 1
	totalHitBeats += 1
	totalPoints += currentMultiplier
	currentMultiplier = min(1 + floor(currentComboCount * 0.5), 8)


func missTheBeat():
	totalMissedBeats += 1
	currentComboCount = 0
	currentMultiplier = 1

func collide():
	totalMissedBeats += 1
	currentComboCount = 0
	totalPoints -= floor(totalPoints * 0.1)
	currentMultiplier = 1
