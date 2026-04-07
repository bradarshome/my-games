extends Control

func _ready():
	$VBoxContainer/Match3Button.pressed.connect(_on_match3_pressed)
	$VBoxContainer/BlockDropButton.pressed.connect(_on_block_drop_pressed)
	$VBoxContainer/SlidePuzzleButton.pressed.connect(_on_slide_pressed)
	$VBoxContainer/PhysicsDropButton.pressed.connect(_on_physics_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_match3_pressed():
	GameManager.set_mode(GameManager.GameMode.MATCH3)
	get_tree().change_scene_to_file("res://scenes/match3.tscn")

func _on_block_drop_pressed():
	GameManager.set_mode(GameManager.GameMode.BLOCK_DROP)
	get_tree().change_scene_to_file("res://scenes/block_drop.tscn")

func _on_slide_pressed():
	GameManager.set_mode(GameManager.GameMode.SLIDE)
	get_tree().change_scene_to_file("res://scenes/slide_puzzle.tscn")

func _on_physics_pressed():
	GameManager.set_mode(GameManager.GameMode.PHYSICS_DROP)
	get_tree().change_scene_to_file("res://scenes/physics_drop.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()