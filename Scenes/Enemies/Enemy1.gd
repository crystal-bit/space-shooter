extends Node2D

signal defeated

export(PackedScene) var EnemyBullet

onready var bullet_container = $Bullets
onready var fire_cooldown: Timer = $FireCooldown

# Enemy Attributes:
export var speed = 500
var hp = 10
var enemy_direction = Vector2()
var pattern
var y_start
var is_shooting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	y_start = self.global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pattern == 1:
		enemy_direction = Vector2(-1, 0)
	elif pattern == 2:
		enemy_direction = Vector2(-1, 0)
		if self.global_position.x <= get_viewport().size.x * 0.75 and y_start <= get_viewport().size.y / 2:
			enemy_direction = Vector2(0, 1)
			if abs(self.global_position.y - y_start) > get_viewport().size.y * 0.3:
				enemy_direction = Vector2(-1, 0)
		if self.global_position.x <= get_viewport().size.x * 0.75 and y_start > get_viewport().size.y / 2:
			enemy_direction = Vector2(0, -1)
			if abs(self.global_position.y - y_start) > get_viewport().size.y * 0.3:
				enemy_direction = Vector2(-1, 0)
	self.global_position += enemy_direction * speed * delta
	
	if $RayCast2D.is_colliding():
		if !is_shooting:
			is_shooting = true
			var bullet = EnemyBullet.instance()
			bullet.position = self.get_position()
			bullet_container.add_child(bullet)
			fire_cooldown.start()
			$AudioStreamPlayer2D.play()
			
# The function lowers enemy's hp and removes the node if hp is <= 0
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("defeated")
		queue_free()


func _on_Timer_timeout():
	is_shooting = false
