extends Node

export(float, EASE) var easing = 1.5
export(NodePath) var level_path
export(NodePath) var parallax_bg_path
export var base_intensity : float = 2.0
export var strong_intensity: float = 4.0
export var duration : float = 0.6


var shake : bool = false setget _set_shake
onready var timer : Timer = $Timer
onready var level: Node2D = get_node(level_path)
onready var parallax_bg: Node2D = get_node(parallax_bg_path)
var dissipate : float = 1.0
var is_strong: bool = false
var intensity: float = self.base_intensity

var original_pos = {
	"level": Vector2(),
	"parallax_bg": Vector2(),
}

func _ready():
	timer.wait_time = duration
	self.shake = false
	# store starting positions
	original_pos.level = level.position
	original_pos.parallax_bg = parallax_bg.position
	

func _process(delta):
	dissipate = ease((timer.time_left / timer.wait_time), easing)
	level.position = original_pos.level + dissipate * Vector2(
		rand_range(-intensity, intensity),
		rand_range(-intensity, intensity)
	)
	parallax_bg.position += dissipate * Vector2(
		rand_range(-intensity, intensity),
		rand_range(-intensity, intensity)
	)
	if dissipate <= 0.01:
		level.position = original_pos.level
		parallax_bg.position = original_pos.parallax_bg
		self.shake = false

func _set_shake(val: bool) -> void:
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