extends Node2D

func _ready():
	self.set_physics_process(true)
	
func start_emission():
	$ExplosionParticles.emitting = true
	$LightParticles.emitting = true
	$SmokeParticles.emitting = true
	$SpeedParticles.emitting = true

