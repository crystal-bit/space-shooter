extends Node

const MAX_AMOUNT_OF_ENEMIES : int = 5

export (PackedScene) var Enemy
export (float) var spawnRate = 1.0
export (float) var enemy_scale = 1.0



func _ready() -> void:
	randomize()
	$SpawnTimer.wait_time = spawnRate
	$SpawnTimer.start()


func _process(delta) -> void:
	pass


func _on_SpawnTimer_timeout() -> void:
	set_spawn_position()
#	if enemyCount < MAX_AMOUNT_OF_ENEMIES:
#		spawnEnemy()
#
#	#optionally, stop timer once we have 5 enemies on screen.
#	#However, this is probably not recommended. Once we have the ability to defeat enemies
#	#we probably want this spawner to be able to add more.
#	else:
#		$SpawnTimer.stop()


func spawnEnemy() -> void:
	var pattern = randf()
	for i in MAX_AMOUNT_OF_ENEMIES:
		var enemy = Enemy.instance()
		enemy.scale = Vector2(enemy_scale, enemy_scale)
		#example of how to add enemy to scene root.
		enemy.global_position = self.global_position + Vector2(125 * i, 0)
		if pattern <= 0.5:
			enemy.pattern = 1
		else:
			enemy.pattern = 2
		get_tree().root.add_child(enemy)

	
func set_spawn_position():
	self.global_position = Vector2(
		get_viewport().size.x + 100, 
		get_viewport().size.y * (0.2 * (randi() % 4 + 1))
	)
	spawnEnemy()
	

