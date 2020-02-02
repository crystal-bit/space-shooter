extends Node2D

func _ready():
	$Label.text="Score:"+FinalScore.get_finalscore()

func _on_RetryButton_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Gameplay/Level1/Level1.tscn")

func _on_QuitButton_pressed() -> void:
	SceneManager.goto_scene("res://Scenes/Main.tscn")
