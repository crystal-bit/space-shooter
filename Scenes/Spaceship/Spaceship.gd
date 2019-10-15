extends KinematicBody2D

export (PackedScene) var Command_Reference = load("res://Scenes/Command/Command.tscn")

export (float) var speed : float = 200

onready var bullet_scene = preload("res://Scenes/Bullet/Bullet.tscn")
onready var bullet_container = get_node("Bullets")
onready var gun_node = get_node("Guns")

export var fire_rate : float = .5

var next_shot = 0
var guns_position = Vector2(100,35)

func _ready():
	
	var W_Button = Command_Reference.instance()
	W_Button.Command("W", KEY_W, "key")
	$Inputs.add_child(W_Button)
	
	var A_Button = Command_Reference.instance()
	A_Button.Command("A", KEY_A, "key")
	$Inputs.add_child(A_Button)
	
	var S_Button = Command_Reference.instance()
	S_Button.Command("S", KEY_S, "key")
	$Inputs.add_child(S_Button)
	
	var D_Button = Command_Reference.instance()
	D_Button.Command("D", KEY_D, "key")
	$Inputs.add_child(D_Button)
	
	var J_Button = Command_Reference.instance()
	J_Button.Command("J", KEY_J, "key")
	$Inputs.add_child(J_Button)	
	#disable physics process after creation
	#so user can't move the spaceship
	self.set_physics_process(false)

func _physics_process(d):
	HandleMovement(d)
	handle_shooting(d)
	
func HandleMovement(d):
	var direction = Vector2(0, 0)
	if getCommand("W").isPressed():
		direction.y =- 1
	if getCommand("S").isPressed():
		direction.y =+ 1
	if getCommand("A").isPressed():
		direction.x =- 1
	if getCommand("D").isPressed():
		direction.x =+ 1
	
	var collider = move_and_collide(direction * speed * d)

func handle_shooting(d):
	if getCommand("J").isPressed():
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
	
func getCommand(ID):
	for cmd in $Inputs.get_children():
		if cmd.ID == ID:
			return cmd