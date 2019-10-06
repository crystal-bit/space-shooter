extends Node

signal isPressed()
signal isReleased()

# TO BE CHANGED to a enum
export (String, "key", "mouseButton", "controllerButton") var inputType

var ID = ""
var inputKey
var isCurrentlyPressed : bool = false


func Command(ID : String, inputKey : int, inputType : String):
	self.ID = ID
	self.inputKey = inputKey
	self.inputType = inputType


func _input(ev):
	if inputKey != null:
		match inputType:
			"key":
				if (ev is InputEventKey) and (ev.scancode == inputKey):
					if isCurrentlyPressed and !ev.pressed:
						emit_signal("isReleased")
					elif !isCurrentlyPressed and ev.pressed:
						emit_signal("isPressed")
					isCurrentlyPressed = ev.pressed

func isPressed():
	return isCurrentlyPressed
