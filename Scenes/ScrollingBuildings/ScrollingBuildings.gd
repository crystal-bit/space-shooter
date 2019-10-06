tool
extends Node2D

export(Texture) var buildingTexture
export(float) var speed = 0.8
export(float, 0, 2000, 0.5) var mirrorDistance = 200 setget set_mirrorDistance
export(float, 0, 1, 0.05) var visibleHeightPercentage = 1 setget set_visibleHeightPercentage

var amountScrolled = 0
var spriteOnTheFarRight: Sprite


func _ready():
	$Sprite.texture = buildingTexture
	updateVisibilityNotifierTo($Sprite)
	fillHorizontalSpace($Sprite)
	setVerticalPosition()
	# TODO: resize VisibilityNotifier to Sprite size


func updateVisibilityNotifierTo(sprite):
	$Sprite/VisibilityNotifier2D.position = sprite.position
	$Sprite/VisibilityNotifier2D.rect.size = sprite.get_rect().size


func fillHorizontalSpace(sprite):
	var spritesCountInViewport = get_viewport_rect().size.x / (sprite.get_rect().size.x * sprite.scale.x)
	var spritesTotal = spritesCountInViewport
	var previousSpr = sprite
	for i in floor(spritesTotal):
		var tileSpr = sprite.duplicate(DUPLICATE_USE_INSTANCING)
		tileSpr.position.x = previousSpr.position.x + previousSpr.get_rect().size.x * previousSpr.scale.x + mirrorDistance
		previousSpr = tileSpr
		connectSignals(tileSpr)
		add_child(tileSpr)
	spriteOnTheFarRight = previousSpr


func setVerticalPosition():
	position.y = get_viewport_rect().size.y - 2 * $Sprite.get_rect().size.y * $Sprite.scale.y * visibleHeightPercentage


func connectSignals(building):
	var vN: VisibilityNotifier2D = building.get_node("VisibilityNotifier2D")
	vN.connect("viewport_exited", self, "onBuildingExitedScreen", [building])


func onBuildingExitedScreen(viewport, building):
	building.position.x = spriteOnTheFarRight.position.x + spriteOnTheFarRight.get_rect().size.x * spriteOnTheFarRight.scale.x + mirrorDistance
	spriteOnTheFarRight = building


func scroll(amount):
	amountScrolled += amount
	if amountScrolled > mirrorDistance:
		amountScrolled = 0
	for building in get_children():
		building.position.x -= amount * speed


func set_visibleHeightPercentage(val):
	visibleHeightPercentage = val
	setVerticalPosition()


func set_mirrorDistance(val):
	resetScene()
	mirrorDistance = val
	fillHorizontalSpace($Sprite)


func resetScene():
	for c in get_children():
		if c != $Sprite:
			c.queue_free()
	

func _on_ScrollingBackground_transition_updated(completionRate, movement):
	scroll(-movement)
	
	