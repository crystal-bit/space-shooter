extends Node2D

export var speed = 500

func _process(delta):
	check_if_on_screen()

func _physics_process(delta):
	move_local_x(-(speed * delta))

func check_if_on_screen():
	if not get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()

#func _on_Area2D_body_entered(collider):
	#if "Player" in collider.get_groups():
	#	if collider.is_idle():
			#This need to be edited to add the powerup to player ship
	#		collider.handle_collision()
	#		queue_free()
