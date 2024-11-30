extends CharacterBody2D

var HP = 100
var attack_power = 10
var combat_state = false
var current_enemy = null

var speed = 400
var player_state

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	player_move(delta)
	
func player_move(delta):
	#var direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("move_right"):
		player_state = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		player_state = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("move_up"):
		player_state = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("move_down"):
		player_state = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = player_state
	
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		if movement == 1:
			$AnimatedSprite2D.play("d_walk")
		elif movement == 0:
			$AnimatedSprite2D.play("right")
	elif dir == "left":
		$AnimatedSprite2D.flip_h = false
		if movement == 1:
			$AnimatedSprite2D.play("a_walk")
		elif movement == 0:
			$AnimatedSprite2D.play("left")
	elif dir == "up":
		$AnimatedSprite2D.flip_h = true
		if movement == 1:
			$AnimatedSprite2D.play("w_walk")
		elif movement == 0:
			$AnimatedSprite2D.play("back")
	elif dir == "down":
		$AnimatedSprite2D.flip_h = true
		if movement == 1:
			$AnimatedSprite2D.play("s_walk")
		elif movement == 0:
			$AnimatedSprite2D.play("idle")

func player():
	pass

# animateed untuk player cmmbat
func _on_area_2d_combat_body_entered(body):
	if body.name == "enemy":
		current_enemy = body
		combat_state = true
		start_combat(body)

func _on_area_2d_combat_body_exited(body):
	if body.name == "enemy":
		current_enemy = null
		combat_state = false

func start_combat(enemy):
	if not combat_state:
		return
	
	print($AnimatedSprite2D.animation)
	# animasi player menyerang berdasarkan arah
	var direction = (enemy.position - position)/speed
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("d_tab")
		else:
			$AnimatedSprite2D.play("a_tab")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("s_tab")
		else:
			$AnimatedSprite2D.play("w_tab")
	
	$attackTimer.start(1)
	$attackTimer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))

func take_damage(amount):
	HP -= amount
	print(HP)
	if HP <= 0:
		player_die()

func player_die():
	combat_state = false
	queue_free() # menghapus player dari game
	
func _on_attack_timer_timeout():
	if combat_state and current_enemy:
		current_enemy.take_damage(attack_power)
