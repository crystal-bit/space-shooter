extends Node2D


func _ready():
	$ScoreHandler.connect("scoreChanged", self, "showPoints")
	$ScoreHandler.connect("multiplierChanged", self, "showMultiplier")
	$AddPoints.connect("pressed", self, "addShipDestroyedPoints")
	$ResetMultiplier.connect("pressed", $ScoreHandler, "resetMultiplier")


func addShipDestroyedPoints():
	$ScoreHandler.addScore(25)


func showPoints(points):
	$Score.text = str(points)


func showMultiplier(multiplier):
	$Score/Multiplier.text = str("x", multiplier)

