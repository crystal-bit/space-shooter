extends Node2D

signal defeated

onready var explosionScene = preload("res://Scenes/Effects/ExplosionAnim.tscn")
onready var powerupScene = preload("res://Scenes/Powerups/Powerup.tscn")
onready var bullet_container = $Bullets
onready var fire_cooldown: Timer = $FireCooldown

export(PackedScene) var EnemyBullet

# Enemy Attributes:
export var speed = 500
var hp = 10
var enemy_direction = Vector2()
var pattern
var y_start
var is_shooting = false
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():


	y_start = self.global_position.y


func _on_Enemy1_defeated():
	create_explosion_anim()
	
	# Add here explosion animation
	rng.randomize()
	var chance = rng.randi_range(1, 10)
	if chance <=2:
		# Should be added a level group in case there will be more than 1 level
		var power = powerupScene.instance()
		#power.position = self.get_position()
		power.position = self.global_position
		power.scale = Vector2(1,1)
		power.powerup_type=1
		power.set_Animation()
		get_parent().add_child(power)
	elif chance==3:
		#10% chance for this powerup
		var power = powerupScene.instance()
		power.position = self.global_position
		power.scale = Vector2(0.6,0.6)
		power.powerup_type=2
		power.set_Animation()
		get_parent().add_child(power)
		
	queue_free()
	
	
func _on_Area2D_body_entered(collider):
	if "Player" in collider.get_groups():
		if collider.is_idle():
			collider.handle_collision()
			_on_Enemy1_defeated()


func _on_FireCooldown_timeout():
	is_shooting = false
	
	
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
	
		# Tracks the position of this instance and destroys it after it gets out of sight
	if self.global_position.x <= -100:
		queue_free()
	
	if $RayCast2D.is_colliding():
		if !is_shooting:
			is_shooting = true
			var bullet = EnemyBullet.instance()
			bullet.position = self.get_position()
			bullet_container.add_child(bullet)
			$AudioStreamPlayer2D.play()
			fire_cooldown.start()
			$AudioStreamPlayer2D.play()
	

# The function lowers enemy's hp and removes the node if hp is <= 0
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("defeated")


func create_explosion_anim():
	var explosionAnim = explosionScene.instance()
	explosionAnim.position = self.global_position
	explosionAnim.scale = Vector2(rand_range(1,2),rand_range(1,2))
	explosionAnim.start_anim()
	get_parent().add_child(explosionAnim)

