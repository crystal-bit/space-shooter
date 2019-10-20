extends AnimatedSprite

func _ready():
	pass


func _on_ExplosionAnim_animation_finished():
	queue_free()
	
	
func start_anim():
	self.playing = true
