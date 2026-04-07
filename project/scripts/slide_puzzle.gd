extends Control

const GRID_SIZE = 4
const TILE_SIZE = 80

var tiles: Array = []
var empty_pos: Vector2i = Vector2i(3, 3)
var moves: int = 0

func _ready():
	$BackButton.pressed.connect(_on_back_pressed)
	$NewGameButton.pressed.connect(_on_new_game_pressed)
	init_tiles()

func init_tiles():
	tiles.clear()
	var num = 1
	for y in range(GRID_SIZE):
		var row = []
		for x in range(GRID_SIZE):
			row.append(num)
			num += 1
		tiles.append(row)
	
	tiles[3][3] = 0
	empty_pos = Vector2i(3, 3)
	moves = 0
	shuffle_tiles()
	update_display()
	$MovesLabel.text = "Moves: 0"
	$WinLabel.visible = false

func shuffle_tiles():
	for i in range(100):
		var moves_avail = []
		if empty_pos.x > 0:
			moves_avail.append(Vector2i(-1, 0))
		if empty_pos.x < GRID_SIZE - 1:
			moves_avail.append(Vector2i(1, 0))
		if empty_pos.y > 0:
			moves_avail.append(Vector2i(0, -1))
		if empty_pos.y < GRID_SIZE - 1:
			moves_avail.append(Vector2i(0, 1))
		
		var dir = moves_avail[randi() % moves_avail.size()]
		var new_empty = empty_pos + dir
		var tile = tiles[new_empty.y][new_empty.x]
		tiles[new_empty.y][new_empty.x] = 0
		tiles[empty_pos.y][empty_pos.x] = tile
		empty_pos = new_empty

func _input(event):
	if event.is_action_pressed("ui_left"):
		try_move(Vector2i(1, 0))
	elif event.is_action_pressed("ui_right"):
		try_move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_up"):
		try_move(Vector2i(0, 1))
	elif event.is_action_pressed("ui_down"):
		try_move(Vector2i(0, -1))

func try_move(dir: Vector2i):
	var new_empty = empty_pos + dir
	if new_empty.x < 0 or new_empty.x >= GRID_SIZE or new_empty.y < 0 or new_empty.y >= GRID_SIZE:
		return
	
	var tile = tiles[new_empty.y][new_empty.x]
	tiles[new_empty.y][new_empty.x] = 0
	tiles[empty_pos.y][empty_pos.x] = tile
	empty_pos = new_empty
	
	moves += 1
	$MovesLabel.text = "Moves: " + str(moves)
	update_display()
	check_win()

func check_win() -> bool:
	var num = 1
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if x == GRID_SIZE - 1 and y == GRID_SIZE - 1:
				if tiles[y][x] != 0:
					return false
			else:
				if tiles[y][x] != num:
					return false
				num += 1
	
	$WinLabel.visible = true
	return true

func update_display():
	queue_redraw()

func _draw():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var tile = tiles[y][x]
			if tile > 0:
				var rect = Rect2(x * TILE_SIZE + 5, y * TILE_SIZE + 100, TILE_SIZE - 5, TILE_SIZE - 5)
				draw_rect(rect, Color("#4ecdc4"))
				draw_rect(rect, Color.WHITE, false, 2)
				var text_pos = Vector2(x * TILE_SIZE + TILE_SIZE/2, y * TILE_SIZE + 100 + TILE_SIZE/2)
				draw_string(ThemeDB.fallback_font, text_pos, str(tile), HORIZONTAL_ALIGNMENT_CENTER, -1, 32)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_game_pressed():
	init_tiles()