extends CanvasLayer

signal game_over

# X and Y coordinates for the first life icon
const ICON_POS_X = 100
const ICON_POS_Y = 50
# The offset, to place the other life icons.
# This number should be set to the width of the icon + a number of pixels to use as a gap between icons
export (float) var icon_offset = 80

# This HUD will draw 4 lives on screen, and then
# give the player one more life that doesn't get a graphic
# it'd be pretty easy to change this behavior
export (int) var max_lives = 4
var current_life_count : int

var life_icons = {}


func _ready() -> void:
	current_life_count = max_lives
	place_health_icons()


func _on_Spaceship_damage_taken():
	remove_life()


func remove_life() -> void:
	if current_life_count == 0:
		#we just lost health, on our last life. It's game over
		print("TODO have a node receive this game_over signal and do something")
		emit_signal("game_over")
	else:
		life_icons.get(current_life_count).visible = false
		current_life_count = current_life_count - 1


func add_life() -> void:
	if current_life_count == max_lives:
		pass
	else:
		current_life_count = current_life_count + 1
		life_icons.get(current_life_count).visible = true


func place_health_icons() -> void:
	$Health_Icon.position = Vector2(ICON_POS_X, ICON_POS_Y)
	life_icons[1] = $Health_Icon
	for i in range(1, max_lives):
		var health_icon = $Health_Icon.duplicate()
		health_icon.position = Vector2(ICON_POS_X + (icon_offset * i), ICON_POS_Y)
		add_child(health_icon)
		# i+1 is used as the key here, so our health_icon's key
		# will be equal to the remaining number of lives
		life_icons[i+1] = health_icon
