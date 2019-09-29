extends Control

export var buttonText = "Text here"
signal pressed

func _ready():
	$Label.text = buttonText

func rectSlideIn():
	$Tween.interpolate_property($TextureButton, "rect_position:x", -$TextureButton.get_rect().size.x, 0, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($TextureButton, "modulate:a", 0, 0.6, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	
func appear():
	$AnimationPlayer.play("appear")
	rectSlideIn()

func _on_Button_pressed():
	emit_signal("pressed")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "appear":
		$TextureButton.disabled = false
