extends Node2D
tool

export(bool) var updateScreen = false
export(bool) var reset = false
export(bool) var testAnimation = false

export(int) var distance = 750
export(int) var duration = 5

var previousMoonX
var deltaMovement = 0

signal transition_completed
signal transition_updated # (completionRate: float, moonXPosition: float)

func _ready():
	resetScene()
	resizeEverything()
	fillHorizontalSpace()
	# on resize, update the background
	get_viewport().connect("size_changed", self, "resizeEverything")
	
	if !Engine.editor_hint:
		moveSprites()

func moveSprites():
	previousMoonX = $SkylineMoon.position.x
	var movementToPositionTheMoonOnTheRight = $SkylineMoon.position.x + $SkylineMoon.get_rect().size.x * $SkylineMoon.scale.x - get_viewport_rect().size.x
	for c in get_children():
		if c.name != "Tween":
			c.get_node("Tween").interpolate_property(c, "position", c.position, c.position + Vector2(-movementToPositionTheMoonOnTheRight, 0), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			c.get_node("Tween").start()
	$SkylineMoon/Tween.connect("tween_step", self, "onTweenStep")

func onTweenStep(twnObj, propertyStr, elapsedTime, value):
	var completionRate = elapsedTime / duration
	deltaMovement = $SkylineMoon.position.x - previousMoonX
	previousMoonX = $SkylineMoon.position.x
	emit_signal("transition_updated", completionRate, deltaMovement)
	if completionRate == 1:
		emit_signal("transition_completed")

func resizeEverything():
	removeDuplicateSprites()
	updateHeight()
	fillHorizontalSpace()

func removeDuplicateSprites():
	for c in get_children():
		# if the child is not the original Sprite
		if c != $SkylineA and c != $SkylineMoon:
			c.queue_free()

func _process(delta):
	if updateScreen:
		_ready()
		updateScreen = false
	if reset:
		resetScene()
		reset = false
	if testAnimation:
		resetScene()
		fillHorizontalSpace()
		moveSprites()
		testAnimation = false
		
func resetScene():
	for c in get_children():
		if c != $SkylineA and c != $SkylineMoon:
			c.queue_free()
		else:
			$SkylineA.position = Vector2()
			$SkylineMoon.position = Vector2($SkylineA.get_rect().size.x, 0)

func fillHorizontalSpace():
	var spritesCountInViewport = get_viewport_rect().size.x / ($SkylineA.get_rect().size.x * $SkylineA.scale.x)
	var spritesToCoverDistance = distance / ($SkylineA.get_rect().size.x * $SkylineA.scale.x)
	var spritesTotal = spritesCountInViewport + spritesToCoverDistance
	var previousSpr = $SkylineA
	for i in floor(spritesTotal) - 1:
		var tileSpr = $SkylineA.duplicate(DUPLICATE_USE_INSTANCING)
		tileSpr.position.x = previousSpr.position.x + previousSpr.get_rect().size.x * previousSpr.scale.x
		previousSpr = tileSpr
		add_child(tileSpr)
	$SkylineMoon.position.x = previousSpr.position.x + previousSpr.get_rect().size.x * previousSpr.scale.x
		
func updateHeight():
	var missing_height = get_viewport_rect().size.y - $SkylineA.get_rect().size.y
	if missing_height > 0 :
		# scale sprite
		var scale_factor = ($SkylineA.get_rect().size.y + missing_height) / $SkylineA.get_rect().size.y
		$SkylineA.scale = Vector2(scale_factor, scale_factor)
		$SkylineMoon.scale = Vector2(scale_factor, scale_factor)
