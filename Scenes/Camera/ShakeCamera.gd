extends Camera2D

export(float, EASE) var easing = 1.5
export var base_intensity : float = 8.0
export var strong_intensity: float = 40.0
export var duration : float = 1.0

var shake : bool = false setget _set_shake
onready var timer : Timer = $Timer
var dissipate : float = 1.0
var is_strong: bool = false
var intensity: float = self.base_intensity

func _ready():
	timer.wait_time = duration
	self.shake = false

func _process(delta):
	dissipate = ease((timer.time_left / timer.wait_time), easing)
	offset = dissipate * Vector2(
		rand_range(-intensity, intensity),
		rand_range(-intensity, intensity)
	)

func _set_shake(val:bool) -> void:
	shake = val
	set_process(val)
	if val:
		timer.start()

func _on_Timer_timeout():
	self.shake = false
	self.is_strong = false
	self.intensity = self.base_intensity

func _on_Spaceship_damage_taken() -> void:
	_set_shake(true)

func _on_HUD_game_over() -> void:
	self.is_strong = true
	self.intensity = self.strong_intensity