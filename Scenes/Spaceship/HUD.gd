extends Node2D

signal game_over

# X and Y coordinates for the first life icon
const iconPosX = 100
const iconPosY = 50
# The offset, to place the other life icons.
# This number should be set to the width of the icon + a number of pixels to use as a gap between icons
export (float) var iconOffset = 80

# This HUD will draw 4 lives on screen, and then
# give the player one more life that doesn't get a graphic
# it'd be pretty easy to change this behavior
export (int) var MAX_LIVES = 4
var currentLifeCount : int

var lifeIcons = {}


func _ready() -> void:
	currentLifeCount = MAX_LIVES
	place_health_icons()


# warning-ignore:unused_argument
func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_left"):
		remove_life()
	elif Input.is_action_just_pressed("ui_right"):
		add_life()
	pass


func remove_life() -> void:
	if currentLifeCount == 0:
		#we just lost health, on our last life. It's game over
		print("TODO have a node receive this game_over signal and do something")
		emit_signal("game_over")
	else:
		lifeIcons.get(currentLifeCount).visible = false
		currentLifeCount = currentLifeCount - 1


func add_life() -> void:
	if currentLifeCount == MAX_LIVES:
		pass
	else:
		currentLifeCount = currentLifeCount + 1
		lifeIcons.get(currentLifeCount).visible = true	


func place_health_icons() -> void:
	$Health_Icon.position = Vector2(iconPosX, iconPosY)
	lifeIcons[1] = $Health_Icon
	for i in range(1, MAX_LIVES):
		var health_icon = $Health_Icon.duplicate()
		health_icon.position = Vector2(iconPosX + (iconOffset * i), iconPosY)
		add_child(health_icon)
		# i+1 is used as the key here, so our health_icon's key
		# will be equal to the remaining number of lives
		lifeIcons[i+1] = health_icon