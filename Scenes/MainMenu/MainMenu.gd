extends Control

signal menuAppeared  # TODO: refactor this into "main buttons appeared"
signal optionsButtonClicked
signal startGameClicked

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartGame/TextureButton.modulate.a = 0
	$VBoxContainer/Options/TextureButton.modulate.a = 0
	$VBoxContainer/Exit/TextureButton.modulate.a = 0

func showMenu():
	$AnimationPlayer.play("MenuAppear")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "MenuAppear"):
		emit_signal("menuAppeared")


func _on_ScrollingBackground_transition_updated(completionPercentage, _moonXPos):
	if completionPercentage > 0.75 && $VBoxContainer/StartGame/Label.modulate.a == 0:
		showMenu()


func _on_StartGame_pressed():
	emit_signal("startGameClicked")
	get_tree().change_scene("res://space-shooter/Scenes/Gameplay/Level1")

func _on_Options_pressed():
	emit_signal("optionsButtonClicked")

func _on_Exit_pressed():
	get_tree().quit()
