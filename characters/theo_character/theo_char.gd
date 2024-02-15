extends CharacterBody2D

var id

@onready var animator = $AnimTheo

var direction = 1
var is_knocked_back = false
var is_falling = false

var knockback_power = Game.power
var gravity = Game.gravity
var acceleration = Game.acceleration
var max_speed = Game.max_speed
var jump_force = Game.jump_force
var jump_count = 0
var max_jumps = 2

var btn_left
var btn_right
var btn_jump
var btn_base_attack
var btn_attack_2

var b


@onready var bullet = preload("res://characters/theo_character/laser.tscn") 



func set_id(ident):
	id = ident
	
func game_status():
	gravity = Game.gravity
	acceleration = Game.acceleration
	jump_force = Game.jump_force

func set_moves(left, right, jump, attack, attack_2):
	self.btn_left = left
	self.btn_right = right
	self.btn_jump = jump
	self.btn_base_attack = attack
	self.btn_attack_2 = attack_2

func shoot():
	if Input.is_action_pressed(btn_attack_2):
		$Timer.start()
		b = bullet.instantiate()
		b.direction = direction
		$".".get_parent().add_child(b)
		if direction == -1:
			b.global_position = $Bulletmark_rigth.global_position
		else:
			b.global_position = $Bulletmark_left.global_position
		

func reset():
	knockback_power = Game.power

func lifeStatus():
	if position.y > 850 and not is_falling:
		is_falling = true
		$theo_falling_snd.play()
		await $theo_falling_snd.finished
		queue_free()
		Game.respawn(id)
		


func _on_attack_sword_body_entered(body):
	print("Theo hit objekt area")
	if body != self and body.has_method("handle_hit"):
		body.handle_hit(direction)

func handle_hit(dir):
	$theo_hurt_snd.play()
	print("Theo handles hit " + str(knockback_power))
	knockback_power += 300
	Game.add_hit(id)
	knockback(dir)

func knockback(dir):
	$knockback_snd.play()
	velocity.x = knockback_power * dir
	velocity.y = -knockback_power
	is_knocked_back = true
	await get_tree().create_timer(0.5).timeout
	is_knocked_back = false
	velocity.x = 0



func _physics_process(delta):
	
	var is_paused = Game.is_game_paused
	if is_paused:
		print("Game is paused")
		return
	
	if $Theo2D.flip_h == true:
		direction = -1
	else:
		direction = 1
		
	
	velocity.y += gravity * delta
	
	var is_attacking = animator.current_animation == "attack_sword_left" or animator.current_animation == "attack_sword_right" or animator.current_animation == "handgun_left"
	
	if Input.is_action_pressed(btn_left) and not is_attacking:
		
		animator.play("run")
		$Theo2D.flip_h = true
		if velocity.x > -1000:
			velocity.x -= acceleration
		
	elif Input.is_action_pressed(btn_right) and not is_attacking:
		
		animator.play("run")
		$Theo2D.flip_h = false
		if velocity.x < 1000:
			velocity.x += acceleration

	elif Input.is_action_just_released(btn_left) or Input.is_action_just_released(btn_right):
		velocity.x = 0
		
	
		
	if not is_attacking and animator.current_animation != "run" and animator.current_animation != "attack_sword_left" and animator.current_animation != "attack_sword_right":
		animator.play("idle")
	
	if is_on_floor():
		jump_count = 0
		
	if ! is_on_floor() and not is_attacking:
		animator.play("jump")
		
	if jump_count < max_jumps and Input.is_action_just_pressed(btn_jump):
		animator.play("jump")
		$theo_jump_snd.play()
		velocity.y = -jump_force
		jump_count += 1

	if Input.is_action_just_pressed(btn_base_attack):
		$theo_punch_snd.play()
		$sword_snd.play()
		if $Theo2D.flip_h:
			animator.play("attack_sword_right")
		else:
			animator.play("attack_sword_left")
	
	if Input.is_action_just_pressed(btn_attack_2):
		if $Timer.is_stopped():
			shoot()
			$theo_hangn.play()
			animator.play("handgun_left")
			$Timer.start()

	game_status()
	move_and_slide()
	lifeStatus()
