extends Node

enum GameMode { MATCH3, BLOCK_DROP, SLIDE, PHYSICS_DROP }

var current_mode: GameMode = GameMode.MATCH3
var score: int = 0
var high_scores: Dictionary = {}

func _ready():
	load_high_scores()

func set_mode(mode: GameMode):
	current_mode = mode

func add_score(points: int):
	score += points

func reset_score():
	score = 0

func get_high_score(mode: GameMode) -> int:
	return high_scores.get(str(mode), 0)

func update_high_score(mode: GameMode):
	var key = str(mode)
	if score > high_scores.get(key, 0):
		high_scores[key] = score
		save_high_scores()

func save_high_scores():
	var file = FileAccess.open("user://high_scores.dat", FileAccess.WRITE)
	if file:
		var json = JSON.new()
		json.stringify(JSON.stringify(high_scores))
		file.store_string(JSON.stringify(high_scores))
		file.close()

func load_high_scores():
	var file = FileAccess.open("user://high_scores.dat", FileAccess.READ)
	if file:
		var json = JSON.new()
		var result = json.parse(file.get_as_text())
		if result == OK:
			high_scores = json.get_data()
		file.close()