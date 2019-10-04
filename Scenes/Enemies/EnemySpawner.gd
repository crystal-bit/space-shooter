extends Node

const MAX_AMOUNT_OF_ENEMIES : int = 5

export (PackedScene) var Enemy
export (float) var spawnRate = 1.0

var enemyCount : int = 0


func _ready() -> void:
	$SpawnTimer.wait_time = spawnRate
	$SpawnTimer.start()


func _process(delta) -> void:
	pass


func _on_SpawnTimer_timeout() -> void:
	if enemyCount < MAX_AMOUNT_OF_ENEMIES:
		spawnEnemy()
	
	#optionally, stop timer once we have 5 enemies on screen.
	#However, this is probably not recommended. Once we have the ability to defeat enemies
	#we probably want this spawner to be able to add more.
	else:
		$SpawnTimer.stop()


func spawnEnemy() -> void:
	var enemy = Enemy.instance()
	#example of how to add enemy to scene root.
	enemy.global_position = Vector2(100 * (enemyCount + 1), 100 * (enemyCount + 1))
	get_tree().root.add_child(enemy)
	enemyCount += 1
