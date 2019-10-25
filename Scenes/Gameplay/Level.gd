extends Node2D


func _ready():
	$ScoreHandler.connect("scoreChanged", self, "showPoints")
	$ScoreHandler.connect("multiplierChanged", self, "showMultiplier")

	#enable physics process on the spaceship
	#once the level is ready
	$Spaceship.set_physics_process(true)


func addShipDestroyedPoints():
	$ScoreHandler.addScore(25)


func showPoints(points):
	$Score.text = str(points)


func showMultiplier(multiplier):
	$Score/Multiplier.text = str("x", multiplier)


