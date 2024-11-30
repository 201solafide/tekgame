extends CharacterBody2D

var HP = 70
var attack_power = 8
var combat_state = false
var current_player = null

var speed = 45
var player_state = false
var player = null

#mengatur animated awal untuk enemy
func _ready():
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta):
	#if player_state:
		#position += (player.position - position)/speed
		
	if player_state:
		chase_player(delta)
	else:
		play_idle_anim()

#func play_combat_anim():
	## animated pertarungan
	#var direction = (player.position - position).normalized()
	## animasi enemy combat berdasarkan arah
	#if abs(direction.x) > abs(direction.y):
		#if direction.x > 0:
			#$AnimatedSprite2D.play("attack_right") #kekanan
		#else:
			#$AnimatedSprite2D.play("attack_left") #kiri
	#else:
		#if direction.y > 0:
			#$AnimatedSprite2D.play("attack_front") #kebawah
		#else:
			#$AnimatedSprite2D.play("attack_back") #keatas
			#
	#move_and_slide()
	
func chase_player(delta):
	var direction = (player.position - position)/speed
	velocity = direction * speed
	
	# animasi enemy berdasarkan arah
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("walk_right") #kekanan
		else:
			$AnimatedSprite2D.play("walk_left") #kiri
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("walk_front") #kebawah
		else:
			$AnimatedSprite2D.play("walk_back") #keatas
	
	move_and_slide()

func play_idle_anim():
	#loop animasi idle
	$AnimatedSprite2D.play("idle_front")

func _on_area_2d_detection_body_entered(body):
	if body.name == "player":
		player = body
		player_state = true

func _on_area_2d_detection_body_exited(body):
	if body.name == "player":
		player = null
		player_state = false
		$AnimatedSprite2D.play("idle_front")

func _on_area_2d_combat_body_entered(body):
	if body.name == "player":
		current_player = body
		combat_state = true
		start_combat(body)
		
func _on_area_2d_combat_body_exited(body):
	if body.name == "player":
		current_player = null
		combat_state = false

func start_combat(player):
	if not combat_state:
		return
	#animasi enemy menyerang
	var direction = (player.position - position).normalized()
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("attack_right")
		else:
			$AnimatedSprite2D.play("attack_left")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("attack_front")
		else:
			$AnimatedSprite2D.play("attack_back")
	
	$attackTimer.start(0.5)
	$attackTimer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	
func take_damage(amount):
	HP -= amount
	if HP <= 0:
		print(HP)
		enemy_die()

func enemy_die():
	combat_state = false
	queue_free()
