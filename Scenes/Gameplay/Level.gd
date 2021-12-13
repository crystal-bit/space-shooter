extends Node2D


func _ready():
	$ScoreHandler.connect("scoreChanged", self, "showPoints")
	$ScoreHandler.connect("multiplierChanged", self, "showMultiplier")

	#enable physics process on the spaceship
	#once the level is ready
	$Spaceship.set_physics_process(true)
	$Spaceship.connect("gameOver", self, "fadeOutBackgroundMusic")

	$Tween.interpolate_property($BackgroundMusic, "volume_db", -80, 0, 1.50, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	$Tween.start()


func addShipDestroyedPoints():
	$ScoreHandler.addScore(25)


func showPoints(points):
	$Score.text = str(points)


func showMultiplier(multiplier):
	$Score/Multiplier.text = str("x", multiplier)


func fadeOutBackgroundMusic():
	$Tween.interpolate_property($BackgroundMusic, "volume_db", 0, -80, 5.00, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$Tween.start()
	gameOver()


func gameOver():
	yield(get_tree().create_timer(2.0), "timeout")
	SceneManager.goto_scene("res://Scenes/Gameplay/Gameover/Gameover.tscn",$Score.text)


