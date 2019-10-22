extends Node2D


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spaceshipArrives":
		$Spaceship/Sprite/AnimationPlayer.play("idle")


func _on_ScrollingBackground_transition_updated(completionPercentage, _moonXPos):
	if completionPercentage > 0.55 and $Spaceship.modulate.a == 0:
		$Spaceship/AnimationPlayer.play("spaceshipArrives")
		
		
func _on_MainButtons_startGameClicked():
	SceneManager.goto_scene("res://Scenes/Gameplay/Level1/Level1.tscn")

