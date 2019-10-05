extends Node2D


func _ready():
	randomize()
	$ScoreHandler.connect("scoreChanged", self, "showPoints")
	$ScoreHandler.connect("multiplierChanged", self, "showMultiplier")
	$AddPoints.connect("pressed", self, "addShipDestroyedPoints")
	$ResetMultiplier.connect("pressed", $ScoreHandler, "resetMultiplier")
	set_spawn_position()


func addShipDestroyedPoints():
	$ScoreHandler.addScore(25)


func showPoints(points):
	$Score.text = str(points)


func showMultiplier(multiplier):
	$Score/Multiplier.text = str("x", multiplier)

func set_spawn_position():
	var viewport_size = get_viewport().size
	$EnemySpawner.global_position = Vector2(viewport_size.x - 100, viewport_size.y/4 + viewport_size.y/2*randf())
	
