extends Node2D

@onready var box_sprite = $AnimatedSprite2D
@onready var label_prompt = $Label
@onready var key_pick = $Area2D_PickKey

# stabe variabel
var is_box_opened = false
var has_key_picked = false

func _on_Area2D_Open_body_entered(body):
	print("name body ", body.name)
	if body.name == "player" and not is_box_opened:
		label_prompt.visible = true
func _on_Area2D_Open_body_exited(body):
	print("name body ", body.name)
	if body.name == "player":
		label_prompt.visible = false

func  _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_box") and label_prompt.visible and not is_box_opened:
		open_box()
		
# fungsi open box
func open_box():
	is_box_opened = true
	box_sprite.play("key_no_box") # ubah animasi ke box terbuka
	label_prompt.visible = false # sembuyikan prompt
	
func _on_Area2D_PickKey_body_entered(body):
	pass
