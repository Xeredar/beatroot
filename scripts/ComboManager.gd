extends Node

var currentComboCount = 0
var currentMultiplier = 1
var totalMissedBeats = 0
var totalHitBeats = 0
var totalPoints = 0
var maximumBeats = 0
var perfectBeats = 0
var greatBeats = 0

func reset():
	currentComboCount = 0
	currentMultiplier = 1
	totalMissedBeats = 0
	totalHitBeats = 0
	totalPoints = 0
	maximumBeats = 0

func hitTheBeat():
	currentComboCount += 1
	totalHitBeats += 1
	totalPoints += currentMultiplier
	currentMultiplier = min(1 + floor(currentComboCount * 0.5), 8)


func hitPerfectBeat():
	perfectBeats += 1


func hitGreatBeat():
	greatBeats += 1


func missTheBeat():
	totalMissedBeats += 1
	currentComboCount = 0
	currentMultiplier = 1

func collide():
	totalMissedBeats += 1
	currentComboCount = 0
	totalPoints -= floor(totalPoints * 0.1)
	currentMultiplier = 1
