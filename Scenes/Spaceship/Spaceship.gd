extends KinematicBody2D

signal gameOver()

onready var bullet_scene = preload("res://Scenes/Bullet/Bullet.tscn")
onready var bullet_powerup=preload("res://Assets/warped city files/sprites/misc/shot/powerupbullet.png")
onready var bullet_container = get_node("Bullets")
onready var gun_node = get_node("Guns")
onready var recovery_timer: Timer = $RecoveryTimer
onready var powerup_timer: Timer = $PowerupTimer
onready var bulletpowerup_timer: Timer=$BulletPowerupTimer
onready var sprite = $Sprite
onready var powerup_sfx: AudioStreamPlayer2D = $PowerupSFX
onready var guns_position = $FirePosition

export(float, 0, 500, .5) var speed = 300
export(float, 0, 2, .1) var fire_rate = 0.3
export(float, 0, 10, .5) var recovery_time = 3

enum State {IDLE, RECOVERY, DEAD}
export(State) var current_state = State.IDLE

var next_shot = 0
var viewport_size
var modified_fire_rate: float = fire_rate
var bulletBoost=1


signal damage_taken()


func _ready():
	init_controls()
	init_recovery_timer()
	#disable physics process after creation
	#so user can't move the spaceship
	set_physics_process(false)
	viewport_size = get_viewport_rect().size


func _physics_process(d):
	if(current_state == State.DEAD):
		return
	handle_movement(d)
	handle_shooting(d)


func _process(d):
	match current_state:
		State.RECOVERY:
			var uniform_periodic = abs(cos(recovery_timer.time_left*PI))
			self.get_node("Sprite").get_material().set_shader_param("whitening", uniform_periodic)
		State.IDLE:
			self.get_node("Sprite").get_material().set_shader_param("whitening", 0)


func _on_Recovery_Timer_timeout():
	current_state = State.IDLE


func _on_PowerupTimer_timeout() -> void:
	modified_fire_rate = fire_rate


func _on_BulletPowerupTimer_timeout():
	bulletBoost=1


func _on_game_over():
	current_state = State.DEAD
	$ExplosionParticleSystem/ExplosionSound.play()
	$ExplosionParticleSystem.start_emission()
	$Sprite.visible = false
	emit_signal("gameOver")
	set_physics_process(false)


func handle_collision():
	if(get_lives() != 0 && current_state == State.IDLE):
		emit_signal("damage_taken")
		$HitSound.play()
		recovery_timer.start()
		current_state = State.RECOVERY


func init_controls():
	pass
#	var j_button = command_reference.instance()
#	j_button.command("J", KEY_J, "key")
#	$Inputs.add_child(j_button)
#
#	var x_button = command_reference.instance()
#	x_button.command("X", KEY_X, "key")
#	$Inputs.add_child(x_button)


func init_recovery_timer():
	recovery_timer.set_one_shot(true)
	recovery_timer.set_wait_time(recovery_time)


func handle_damage_visual_effects():
	match current_state:
		State.RECOVERY:
			var toWhite = abs(cos(recovery_timer.time_left*PI))
			self.get_node("Sprite").get_material().set_shader_param("whitening", toWhite)
		State.IDLE:
			self.get_node("Sprite").get_material().set_shader_param("whitening", 0)


func handle_movement(d):
	var direction = Vector2(0, 0)
	# keyboard input
	if Input.is_action_pressed("ui_up"):
		direction.y =- 1
	if Input.is_action_pressed("ui_down"):
		direction.y =+ 1
	if Input.is_action_pressed("ui_left"):
		direction.x =- 1
	if Input.is_action_pressed("ui_right"):
		direction.x =+ 1
	# touch input
	move_and_collide(direction * speed * d)
	clamp_position_to_viewport_size()


func clamp_position_to_viewport_size():
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, 0, viewport_size.y)


func handle_shooting(d):
	if Input.is_action_pressed("fire"):
		fire(d)
	else:
		decrease_next_shot_remaining_time(d)


func fire(d):
	if next_shot <= 0:
		var bullet = bullet_scene.instance()
		bullet.damage*=bulletBoost
		bullet.position =  guns_position.global_position
		if(bulletBoost==2):
			bullet.get_node("Sprite").texture=bullet_powerup
			bullet.position.y+=8  #for being more accurate to gun's position
		bullet_container.add_child(bullet)
		next_shot = modified_fire_rate
		$AudioStreamPlayer2D.play()
	else:
		decrease_next_shot_remaining_time(d)


func decrease_next_shot_remaining_time(d):
	next_shot -= d


func is_idle() -> bool:
	return true if current_state == State.IDLE else false


func activate_powerup(type):
	if type==1:
		modified_fire_rate = 0.55 * fire_rate
		powerup_timer.start()
	elif type==2:
		bulletBoost=2
		bulletpowerup_timer.start()
	powerup_sfx.play()


func get_lives():
	return get_parent().get_node("HUD").current_life_count+1


