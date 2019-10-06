extends Panel

var SAVE_FILE_PATH = "res://settings.cfg" 

var config: ConfigFile


func _ready():
	config = getConfigFile()
	

func show():
	"""This overrides the default show() method."""
	visible = true
	setSceneValuesFromConfig(config)
	
	
func getConfigFile() -> ConfigFile:
	""" Loads the ConfigFile and returns it. 
	If unsuccesfull returns an error code. 
	"""
	var config = ConfigFile.new()
	var f = File.new()
	# creates file if it does not exists
	if !f.file_exists(SAVE_FILE_PATH):
		config.save(SAVE_FILE_PATH)
	# load the file
	var err = config.load(SAVE_FILE_PATH)
	# if file loaded
	if err == OK:
		# check if keys exist. If not, set them to default values
		if not config.has_section_key("general", "playerName"):
			config.set_value("general", "playerName", "")
		if not config.has_section_key("general", "showSpaceship"):
			config.set_value("general", "showSpaceship", true)
		if not config.has_section_key("audio", "volume"):
			config.set_value("audio", "volume", 0)
		# return it
		return config
	else:
		print("Error while loading config ", err)
		return err
		

func saveConfig(config: ConfigFile):
	config.set_value("general", "playerName", $VBoxContainer/PlayerName/LineEdit.text)
	config.set_value("general", "showSpaceship", $VBoxContainer/ShowSpaceShip/CheckBox.pressed)
	config.set_value("audio", "volume", $VBoxContainer/Volume/HSlider.value)
	# Save the changes by overwriting the previous file
	config.save(SAVE_FILE_PATH)
	

func setSceneValuesFromConfig(config: ConfigFile):
	$VBoxContainer/ShowSpaceShip/CheckBox.pressed = config.get_value("general", "showSpaceship")
	$VBoxContainer/Volume/HSlider.value = config.get_value("audio", "volume")
	$VBoxContainer/PlayerName/LineEdit.text = config.get_value("general", "playerName")


# signal bindings

func _on_Cancel_pressed():
	hide()
	# reset initial values
	setSceneValuesFromConfig(config)


func _on_Ok_pressed():
	hide()
	saveConfig(config)