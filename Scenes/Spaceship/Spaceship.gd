extends KinematicBody2D

export (PackedScene) var Command_Reference = load("res://Scenes/Command/Command.tscn")

export (float) var speed : float = 200


func _ready():
	var W_Button = Command_Reference.instance()
	W_Button.Command("W", KEY_W, "key")
	$Inputs.add_child(W_Button)
	
	var A_Button = Command_Reference.instance()
	A_Button.Command("A", KEY_A, "key")
	$Inputs.add_child(A_Button)
	
	var S_Button = Command_Reference.instance()
	S_Button.Command("S", KEY_S, "key")
	$Inputs.add_child(S_Button)
	
	var D_Button = Command_Reference.instance()
	D_Button.Command("D", KEY_D, "key")
	$Inputs.add_child(D_Button)


func _physics_process(d):
	HandleMovement(d)


func HandleMovement(d):
	var direction = Vector2(0, 0)
	if getCommand("W").isPressed():
		direction.y =- 1
	if getCommand("S").isPressed():
		direction.y =+ 1
	if getCommand("A").isPressed():
		direction.x =- 1
	if getCommand("D").isPressed():
		direction.x =+ 1
	
	var collider = move_and_collide(direction * speed * d)


func getCommand(ID):
	for cmd in $Inputs.get_children():
		if cmd.ID == ID:
			return cmd
