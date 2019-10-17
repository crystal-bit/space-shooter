extends Node2D

export var speed : float = 250.0

func _ready():
	pass

func _process(delta):
	check_if_on_screen()
		
func check_if_on_screen():
	if not get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()

func _physics_process(delta):
	move_local_x(speed * delta)