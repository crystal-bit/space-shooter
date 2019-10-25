extends Node2D

export var speed = 200

func _process(delta):
	check_if_on_screen()

func _physics_process(delta):
	move_local_x(-(speed * delta))

func check_if_on_screen():
	if not get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if "Player" in body.get_groups():
		body.play_powerup_sfx()
		queue_free()
