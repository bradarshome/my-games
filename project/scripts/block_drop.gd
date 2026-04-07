extends Control

const GRID_WIDTH = 10
const GRID_HEIGHT = 20
const TILE_SIZE = 32
const COLORS = ["#ff6b6b", "#4ecdc4", "#45b7d1", "#96ceb4", "#ffeaa7", "#dfe6e9"]

var grid: Array = []
var current_block: Array = []
var current_x: int = GRID_WIDTH / 2 - 1
var game_over: bool = false
var drop_timer: float = 0.0
var drop_speed: float = 1.0

func _ready():
	$BackButton.pressed.connect(_on_back_pressed)
	$NewGameButton.pressed.connect(_on_new_game_pressed)
	new_game()

func new_game():
	grid.clear()
	for y in range(GRID_HEIGHT):
		var row = []
		row.resize(GRID_WIDTH)
		row.fill(-1)
		grid.append(row)
	
	current_x = GRID_WIDTH / 2 - 1
	game_over = false
	drop_speed = 1.0
	spawn_block()
	update_display()
	$GameOverLabel.visible = false
	GameManager.reset_score()
	$ScoreLabel.text = "Score: 0"

func spawn_block():
	var block_shapes = [
		[[0, 0]],
		[[0, 0], [1, 0]],
		[[0, 0], [1, 0], [2, 0]],
		[[0, 0], [1, 0], [0, 1], [1, 1]],
		[[0, 0], [1, 0], [-1, 0]],
		[[0, 0], [1, 0], [1, 1], [2, 1]]
	]
	current_block = block_shapes[randi() % block_shapes.size()].duplicate()
	current_x = GRID_WIDTH / 2 - 1
	
	for cell in current_block:
		var gy = GRID_HEIGHT - 1
		for row in grid:
			pass
		if can_place(current_x, 0):
			return
	
	game_over = true
	$GameOverLabel.visible = true

func can_place(x: int, y: int) -> bool:
	for cell in current_block:
		var cx = x + cell[0]
		var cy = y + cell[1]
		if cx < 0 or cx >= GRID_WIDTH:
			return false
		if cy >= GRID_HEIGHT:
			return false
		if cy >= 0 and grid[cy][cx] != -1:
			return false
	return true

func place_block():
	for cell in current_block:
		var cx = current_x + cell[0]
		var cy = GRID_HEIGHT - 1 + cell[1]
		if cy >= 0 and cy < GRID_HEIGHT:
			grid[cy][cx] = randi() % COLORS.size()
	
	GameManager.add_score(current_block.size() * 10)
	$ScoreLabel.text = "Score: " + str(GameManager.score)
	check_lines()
	spawn_block()
	update_display()

func check_lines():
	var lines_cleared = 0
	for y in range(GRID_HEIGHT):
		var full = true
		for x in range(GRID_WIDTH):
			if grid[y][x] == -1:
				full = false
				break
		if full:
			lines_cleared += 1
			for k in range(y, GRID_HEIGHT - 1):
				for x in range(GRID_WIDTH):
					grid[k][x] = grid[k+1][x]
			for x in range(GRID_WIDTH):
				grid[GRID_HEIGHT-1][x] = -1
	
	if lines_cleared > 0:
		GameManager.add_score(lines_cleared * 100)
		$ScoreLabel.text = "Score: " + str(GameManager.score)

func _input(event):
	if game_over:
		return
	
	if event.is_action_pressed("ui_left"):
		move(-1)
	elif event.is_action_pressed("ui_right"):
		move(1)
	elif event.is_action_pressed("ui_down"):
		move_down()
	elif event.is_action_pressed("ui_accept"):
		rotate_block()

func move(dir: int):
	if can_place(current_x + dir, GRID_HEIGHT - 1):
		current_x += dir
		update_display()

func move_down():
	if can_place(current_x, GRID_HEIGHT - 2):
		pass
	else:
		place_block()
		return
	
	for cell in current_block:
		var cy = GRID_HEIGHT - 1 + cell[1]
		if cy < GRID_HEIGHT - 1:
			cell[1] += 1
	
	drop_timer = 0.0
	update_display()

func rotate_block():
	var rotated = []
	for cell in current_block:
		rotated.append([-cell[1], cell[0]])
	
	var old = current_block.duplicate()
	current_block = rotated
	
	if not can_place(current_x, GRID_HEIGHT - 1):
		current_block = old
	
	update_display()

func _process(delta):
	if game_over:
		return
	
	drop_timer += delta
	if drop_timer >= drop_speed:
		drop_timer = 0.0
		if not can_place(current_x, GRID_HEIGHT - 2):
			place_block()
		else:
			for cell in current_block:
				cell[1] += 1
		update_display()

func update_display():
	queue_redraw()

func _draw():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x] >= 0:
				var rect = Rect2(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE - 1, TILE_SIZE - 1)
				draw_rect(rect, Color(HEX2R(COLORS[grid[y][x]])))
	
	for cell in current_block:
		var cx = current_x + cell[0]
		var cy = GRID_HEIGHT - 1 + cell[1]
		if cy >= 0 and cy < GRID_HEIGHT and cx >= 0 and cx < GRID_WIDTH:
			var rect = Rect2(cx * TILE_SIZE, cy * TILE_SIZE, TILE_SIZE - 1, TILE_SIZE - 1)
			draw_rect(rect, Color.WHITE)

func HEX2R(hex: String) -> Color:
	return Color(hex)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_game_pressed():
	new_game()