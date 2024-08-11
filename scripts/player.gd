extends CharacterBody2D

const SPEED = 60
var current_dir = "none"

var attack_timer = 0
var allow_attack = true
const ATTACK_SPEED = 0.5

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
func _physics_process(delta):
	player_movement(delta)
	attack(delta)
	
func player_movement(_delta):
	if Input.is_action_pressed("right_walk"):
		current_dir = "right"
		play_anim(1)
		
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left_walk"):
		current_dir = "left"
		play_anim(1)
		
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("up_walk"):
		current_dir = "up"
		play_anim(1)
		
		velocity.x = 0
		velocity.y = -SPEED
	elif Input.is_action_pressed("down_walk"):
		current_dir = "down"
		play_anim(1)
		
		velocity.x = 0
		velocity.y = SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()
	
func attack(delta):
	if attack_timer < ATTACK_SPEED:
		attack_timer += delta
		allow_attack = false
	else:
		allow_attack = true
	
	if Input.is_action_pressed("attack"):
		if allow_attack == true:
			pass

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
