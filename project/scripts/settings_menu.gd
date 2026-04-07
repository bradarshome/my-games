extends Control

func _ready():
	$BackButton.pressed.connect(_on_back_pressed)
	$MusicCheck.button_toggled.connect(_on_music_toggled)
	$SfxCheck.button_toggled.connect(_on_sfx_toggled)
	$FullscreenCheck.button_toggled.connect(_on_fullscreen_toggled)
	
	$MusicCheck.button_pressed = Settings.music_enabled
	$SfxCheck.button_pressed = Settings.sfx_enabled
	$FullscreenCheck.button_pressed = Settings.fullscreen

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_music_toggled(toggled_on):
	Settings.set_music(toggled_on)

func _on_sfx_toggled(toggled_on):
	Settings.set_sfx(toggled_on)

func _on_fullscreen_toggled(toggled_on):
	Settings.set_fullscreen(toggled_on)