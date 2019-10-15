extends Node

var SAVE_FILE_PATH = "res://settings.cfg"


func _ready():
	read_volume_from_config()
		
	
func _on_volume_changed(var volume_ratio : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume_ratio))
	

func read_volume_from_config():
	var config = ConfigFile.new()
	
	var err = config.load(SAVE_FILE_PATH)
	if err == OK:
		var ratio = config.get_value("audio", "volume", 100) / 100
		_on_volume_changed(ratio)