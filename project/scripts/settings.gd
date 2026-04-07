extends Node

const SETTINGS_FILE = "user://settings.json"

var music_enabled: bool = true
var sfx_enabled: bool = true
var fullscreen: bool = false

func _ready():
	load_settings()

func set_music(enabled: bool):
	music_enabled = enabled
	save_settings()

func set_sfx(enabled: bool):
	sfx_enabled = enabled
	save_settings()

func set_fullscreen(enabled: bool):
	fullscreen = enabled
	if DisplayServer:
		if enabled:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func save_settings():
	var data = {
		"music_enabled": music_enabled,
		"sfx_enabled": sfx_enabled,
		"fullscreen": fullscreen
	}
	var file = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_settings():
	if FileAccess.file_exists(SETTINGS_FILE):
		var file = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
		if file:
			var json = JSON.new()
			var result = json.parse(file.get_as_text())
			if result == OK:
				var data = json.get_data()
				music_enabled = data.get("music_enabled", true)
				sfx_enabled = data.get("sfx_enabled", true)
				fullscreen = data.get("fullscreen", false)
			file.close()