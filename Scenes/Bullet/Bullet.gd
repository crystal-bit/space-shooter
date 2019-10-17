extends Node2D

export var speed : float = 250.0
var damage = 5

func _ready():
	pass

func _process(delta):
	check_if_on_screen()
	
func check_if_on_screen():
	if not get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()

func _physics_process(delta):
	move_local_x(speed * delta)

func _on_Area2D_area_entered(area):
	var area_root = area.get_parent();
	if "Enemy" in area_root.get_groups():
		area_root.take_damage(damage)
		queue_free()
