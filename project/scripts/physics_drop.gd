extends Control

var balls: Array = []
var drop_timer: float = 0.0
var drop_interval: float = 1.5
var score: int = 0

func _ready():
	$DropButton.pressed.connect(_on_drop_pressed)
	$BackButton.pressed.connect(_on_back_pressed)
	$NewGameButton.pressed.connect(_on_new_game_pressed)
	$DropZone.position = Vector2(200, 550)

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_down"):
		drop_ball()

func drop_ball():
	var ball = CharacterBody2D.new()
	ball.position = Vector2(randf_range(50, 400), 80)
	
	var sprite = ColorRect.new()
	sprite.color = Color("#ff6b6b")
	sprite.size = Vector2(24, 24)
	sprite.set_anchors_preset(Control.PRESET_CENTER)
	ball.add_child(sprite)
	
	var collider = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(24, 24)
	collider.shape = shape
	ball.add_child(collider)
	
	ball.set_script(null)  # No separate script needed
	add_child(ball)
	balls.append(ball)

func _process(delta):
	for ball in balls:
		ball.velocity.y += 500 * delta
		ball.move_and_slide()
		
		if ball.position.y > 750:
			ball.queue_free()
			balls.erase(ball)
			continue
		
		var zone = $DropZone
		if ball.global_position.x > zone.position.x and ball.global_position.x < zone.position.x + zone.size.x:
			if ball.global_position.y > zone.position.y and ball.global_position.y < zone.position.y + zone.size.y:
				score += 10
				ball.queue_free()
				balls.erase(ball)
	
	$ScoreLabel.text = "Score: " + str(score)

func _on_drop_pressed():
	drop_ball()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_game_pressed():
	for ball in balls:
		ball.queue_free()
	balls.clear()
	score = 0
	$ScoreLabel.text = "Score: 0"