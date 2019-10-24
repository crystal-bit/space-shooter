extends Node2D

func _ready():
	pass
	
func start_emission():
	$ExplosionParticles.emitting = true
	$LightParticles.emitting = true
	$SmokeParticles.emitting = true
	$SpeedParticles.emitting = true

