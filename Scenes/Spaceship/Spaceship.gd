extends KinematicBody2D

onready var bullet_scene = preload("res://Scenes/Bullet/Bullet.tscn")
onready var bullet_container = get_node("Bullets")
onready var gun_node = get_node("Guns")
onready var recovery_timer: Timer = $RecoveryTimer
onready var sprite = $Sprite

export(PackedScene) var command_reference = load("res://Scenes/Command/Command.tscn")
export(float, 0, 500, .5) var speed = 200
export(float, 0, 10, .5) var fire_rate = 1
export(float, 0, 10, .5) var recovery_time = 3

enum State {IDLE, RECOVERY}
export(State) var current_state = State.IDLE

var next_shot = 0
var guns_position = Vector2(100,35)

signal damage_taken()

func _ready():
	init_controls()
	init_recovery_timer()
	
	#disable physics process after creation
	#so user can't move the spaceship
	self.set_physics_process(false)


func _physics_process(d):
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
	
	
func handle_collision():
	if(current_state == State.IDLE):
		emit_signal("damage_taken")
		recovery_timer.start()
		current_state = State.RECOVERY
	
	
func init_controls():
	var w_button = command_reference.instance()
	w_button.command("W", KEY_W, "key")
	$Inputs.add_child(w_button)
	
	var a_button = command_reference.instance()
	a_button.command("A", KEY_A, "key")
	$Inputs.add_child(a_button)
	4
	var s_button = command_reference.instance()
	s_button.command("S", KEY_S, "key")
	$Inputs.add_child(s_button)
	
	var d_button = command_reference.instance()
	d_button.command("D", KEY_D, "key")
	$Inputs.add_child(d_button)
	
	var j_button = command_reference.instance()
	j_button.command("J", KEY_J, "key")
	$Inputs.add_child(j_button)
	
	 
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
	if get_command("W").isPressed():
		direction.y =- 1
	if get_command("S").isPressed():
		direction.y =+ 1
	if get_command("A").isPressed():
		direction.x =- 1
	if get_command("D").isPressed():
		direction.x =+ 1
	
	move_and_collide(direction * speed * d)


func handle_shooting(d):
	if get_command("J").isPressed():
		fire(d)
	else:
		decrease_next_shot_remaining_time(d)
		
		
func fire(d):
	if next_shot <= 0:
		var bullet = bullet_scene.instance()
		bullet.position = self.get_position() + guns_position
		bullet_container.add_child(bullet)
		next_shot = fire_rate
		$AudioStreamPlayer2D.play()
	else:
		decrease_next_shot_remaining_time(d)
	
	
func decrease_next_shot_remaining_time(d):
	next_shot -= d
	
	
func is_idle() -> bool:
	return true if current_state == State.IDLE else false
	

func get_command(ID):
	for cmd in $Inputs.get_children():
		if cmd.ID == ID:
			return cmd
			
			