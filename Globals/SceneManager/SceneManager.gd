extends Node

var current_scene: Node = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path: String, params = null):
	call_deferred("_deferred_goto_scene", path, params)

func _deferred_goto_scene(path: String, params = null):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	if params:
		current_scene.init(params)
