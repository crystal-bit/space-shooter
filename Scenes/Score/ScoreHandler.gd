extends Node

signal scoreChanged(score)
signal multiplierChanged(multiplier)

var currentScore = 0
var multiplier = 1

# can be either 0 (0-5 sec), 1 (5-10 sec), 2 (10-30)
enum eMultiplierLevel {LEVEL_0 = 0, LEVEL_1 = 1, LEVEL_2 = 2}
var multiplierLevel = eMultiplierLevel.LEVEL_0


func _ready():
	$ScoreTimer.connect("timeout", self, "addTimePoints")
	$ScoreTimer.wait_time = 5
	$MultiplierTimer.connect("timeout", self, "upgradeMultiplier")
	$MultiplierTimer.wait_time = 5
	
	startTimers()


func addScore(points):
	currentScore += multiplier * points
	emit_signal("scoreChanged", currentScore)


func changeMultiplier(newMultiplier):
	multiplier = newMultiplier
	emit_signal("multiplierChanged", multiplier)


func getScore():
	return currentScore


func startTimers():
	$ScoreTimer.start()
	$MultiplierTimer.start()


#add a boolean to check if the player is being hit in case the func gets called in the same time the player gets hurt
func upgradeMultiplier():
	match (multiplierLevel):
		eMultiplierLevel.LEVEL_0:
			multiplierLevel = eMultiplierLevel.LEVEL_1
			$MultiplierTimer.stop()
			changeMultiplier(2)
			$MultiplierTimer.wait_time = 5
			$MultiplierTimer.start()
		eMultiplierLevel.LEVEL_1:
			multiplierLevel = eMultiplierLevel.LEVEL_2
			$MultiplierTimer.stop()
			changeMultiplier(4)
			$MultiplierTimer.wait_time = 20
			$MultiplierTimer.start()
		eMultiplierLevel.LEVEL_2:
			$MultiplierTimer.stop()
			changeMultiplier(5)


func resetMultiplier():
	multiplierLevel = eMultiplierLevel.LEVEL_0
	changeMultiplier(1)
	$MultiplierTimer.stop()
	$MultiplierTimer.wait_time = 5
	$MultiplierTimer.start()


func addTimePoints():
	addScore(5)

