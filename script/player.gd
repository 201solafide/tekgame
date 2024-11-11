extends CharacterBody2D

var speed = 100
var player_state

var attacking = false # status serangan
var move_while_attack = false # status apakah character bergerak saat menyerang

func _physics_process(delta):
	#var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# mengecek apakah pemain sedang menyerang tanpa bergerak
	if not attacking:
		# jika sedang bergerak
		if direction == Vector2.ZERO:
			player_state = "idle"
		else:
			player_state = "walking"
			move_character(direction)
	elif move_while_attack:
		# mengecek bergerak saat menyerang
		move_character(direction)
	
	play_anim(direction)
	
	player() # input serangan
	
	# mengecek arah pergerakkan
	#if direction.x == 0 and direction.y == 0:
		#player_state = "idle"
	#elif direction.x != 0 or direction.y != 0:
		#player_state = "walking"
		#
	#velocity = direction * speed
	#move_and_slide()
	#
	#play_anim(direction)
	#player()
func move_character(dir):
	velocity = dir * speed
	move_and_slide()
	
func play_anim(dir):
	if player_state == "idle" and not attacking:
		$AnimatedSprite2D.play("idle")
	if player_state == "walking" and not attacking:
		if dir.y == -1:
			$AnimatedSprite2D.play("w_walk") # ke atas
		if dir.x == 1:
			$AnimatedSprite2D.play("d_walk") # ke kanan
		if dir.y == 1:
			$AnimatedSprite2D.play("s_walk") # ke bawah
		if dir.x == -1:
			$AnimatedSprite2D.play("a_walk") # ke kiri
		
		if dir.x > 0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("d_walk")
		if dir.x > 0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("d_walk")
		if dir.x < -0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("a_walk")
		if dir.x < -0.5 and dir.y < -0.5:			
			$AnimatedSprite2D.play("a_walk")
	if attacking:
		# animasi serangan sesuai arah
		if dir.y == -1:
			$AnimatedSprite2D.play("w_tab")
		elif dir.x == 1:
			$AnimatedSprite2D.play("d_tab")
		elif dir.y == 1:
			$AnimatedSprite2D.play("s_tab")
		elif dir.x == -1:
			$AnimatedSprite2D.play("a_tab")
		else:
			$AnimatedSprite2D.play("s_tab")
func player():
	# mengecek apakah spasi ditekan
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true # set status menyeranga
		move_while_attack = Input.get_vector("left", "right", "up", "down")
		attack()

func attack():
	# menyimpan durasi serngan
	var attack_duration = 0.4
	await get_tree().create_timer(attack_duration).timeout
	attacking = false
	move_while_attack = false
		
