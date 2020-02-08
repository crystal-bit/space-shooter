extends Node2D

export var speed = 200

var powerup_type

func _process(delta):
	check_if_on_screen()

func _physics_process(delta):
	move_local_x(-(speed * delta))

func set_Animation():
	if powerup_type==1:
		$AnimatedSprite.play("default")
	elif powerup_type==2:
		$AnimatedSprite.play("RedOrb")


func check_if_on_screen():
	if not get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if "Player" in body.get_groups():
		body.activate_powerup(powerup_type)
		queue_free()

