extends Control

const GRID_SIZE = 8
const TILE_SIZE = 48
const COLORS = ["#ff6b6b", "#4ecdc4", "#45b7d1", "#96ceb4", "#ffeaa7", "#dfe6e9"]

var grid: Array = []
var selected_tile: Vector2i = Vector2i(-1, -1)
var is_swapping: bool = false

func _ready():
	$BackButton.pressed.connect(_on_back_pressed)
	$NewGameButton.pressed.connect(_on_new_game_pressed)
	init_grid()
	update_display()

func init_grid():
	grid.clear()
	for y in range(GRID_SIZE):
		var row = []
		for x in range(GRID_SIZE):
			row.append(randi() % COLORS.size())
		grid.append(row)
	remove_matches()
	GameManager.reset_score()
	$ScoreLabel.text = "Score: 0"

func remove_matches():
	var to_remove = []
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if check_match(x, y):
				to_remove.append(Vector2i(x, y))
	
	for pos in to_remove:
		grid[pos.y][pos.x] = -1
	
	if to_remove.size() > 0:
		await get_tree().create_timer(0.2).timeout
		fill_empty()
		remove_matches()

func check_match(x: int, y: int) -> bool:
	if x < 0 or x >= GRID_SIZE or y < 0 or y >= GRID_SIZE:
		return false
	if grid[y][x] == -1:
		return false
	
	var color = grid[y][x]
	
	if x >= 2 and grid[y][x-1] == color and grid[y][x-2] == color:
		return true
	if y >= 2 and grid[y-1][x] == color and grid[y-2][x] == color:
		return true
	
	return false

func fill_empty():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x] == -1:
				for k in range(y, 0, -1):
					grid[k][y][x] = grid[k-1][x]
				grid[0][x] = randi() % COLORS.size()

func _on_tile_clicked(x: int, y: int):
	if is_swapping:
		return
	
	if selected_tile == Vector2i(-1, -1):
		selected_tile = Vector2i(x, y)
	else:
		await swap_tiles(selected_tile.x, selected_tile.y, x, y)
		selected_tile = Vector2i(-1, -1)

func swap_tiles(x1: int, y1: int, x2: int, y2: int):
	is_swapping = true
	
	var temp = grid[y1][x1]
	grid[y1][x1] = grid[y2][x2]
	grid[y2][x2] = temp
	
	update_display()
	await get_tree().create_timer(0.3).timeout
	
	if not has_valid_matches():
		temp = grid[y1][x1]
		grid[y1][x1] = grid[y2][x2]
		grid[y2][x2] = temp
		update_display()
	
	is_swapping = false
	remove_matches()
	update_score()

func has_valid_matches() -> bool:
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if x < GRID_SIZE - 1:
				var temp = grid[y][x]
				grid[y][x] = grid[y][x+1]
				grid[y][x+1] = temp
				if check_match(x, y) or check_match(x+1, y):
					grid[y][x+1] = grid[y][x]
					grid[y][x] = temp
					return true
				grid[y][x+1] = grid[y][x]
				grid[y][x] = temp
			
			if y < GRID_SIZE - 1:
				var temp = grid[y][x]
				grid[y][x] = grid[y+1][x]
				grid[y+1][x] = temp
				if check_match(x, y) or check_match(x, y+1):
					grid[y+1][x] = grid[y][x]
					grid[y][x] = temp
					return true
				grid[y+1][x] = grid[y][x]
				grid[y][x] = temp
	
	return false

func update_score():
	var matches = 0
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x] == -1:
				matches += 1
	
	if matches > 0:
		GameManager.add_score(matches * 10)
		$ScoreLabel.text = "Score: " + str(GameManager.score)

func update_display():
	$GridContainer.clear()
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x] >= 0:
				var color = Color(HEX2R(COLORS[grid[y][x]]))
				var rect = Rect2(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE - 2, TILE_SIZE - 2)
				$GridContainer.draw_rect(rect, color)
				if selected_tile == Vector2i(x, y):
					$GridContainer.draw_rect(rect, Color.WHITE, false, 2)

func HEX2R(hex: String) -> Color:
	var r = Color(hex)
	return r

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_game_pressed():
	init_grid()
	update_display()