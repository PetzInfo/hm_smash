extends CharacterBody2D

var id

@onready var animator = $AnimPetzi

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


func lifeStatus():
	if position.y > 850 and not is_falling:
		is_falling = true
		$petzi_falling_snd.play()
		await $petzi_falling_snd.finished
		queue_free()
		Game.respawn(id)


func _on_kick_attack_body_entered(body):
	print("Petzi hit objekt area")
	if body != self and body.has_method("handle_hit"):
		body.handle_hit(direction)

func _on_uppercut_attack_body_entered(body):
	if body != self and body.has_method("handle_hit"):
		body.handle_hit(direction)


func handle_hit(dir):
	$petziHurt_snd.play()
	print("default petzi handles hit " + str(knockback_power))
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
	print(delta)
	print(velocity.x)
	var is_paused = Game.is_game_paused
	if is_paused:
		print("Game is paused")
		return
	
	velocity.y += gravity * delta
	
	if $Petzi2D.flip_h == true:
		direction = -1
	else:
		direction = 1
	
	var is_attacking = animator.current_animation == "kick_attack_L" or animator.current_animation == "kick_attack_R" or animator.current_animation == "uppercut_L" or animator.current_animation == "uppercut_R"
	
	if Input.is_action_pressed(btn_left) and not is_attacking:	
		animator.play("run")
		$Petzi2D.flip_h = true
		if velocity.x > -1000:
			velocity.x -= acceleration * delta
		
	elif Input.is_action_pressed(btn_right) and not is_attacking:
		animator.play("run")
		$Petzi2D.flip_h = false
		if velocity.x < 1000:
			velocity.x += acceleration * delta

	elif Input.is_action_just_released(btn_left) or Input.is_action_just_released(btn_right):
		velocity.x = 0
		
		
	if not is_attacking and animator.current_animation != "run" and animator.current_animation != "schlagen" and animator.current_animation != "schlagen_links":
		animator.play("Idle")
	
	if is_on_floor():
		jump_count = 0
		
	if ! is_on_floor() and not is_attacking:
		animator.play("jump")
	
	if jump_count < max_jumps and Input.is_action_just_pressed(btn_jump):
		$petzi_jump_snd.play()
		animator.play("jump")
		velocity.y = -jump_force
		jump_count += 1

	if Input.is_action_just_pressed(btn_base_attack) and animator.current_animation != "uppercut_R" and animator.current_animation != "uppercut_L":
		$petzi_kick_snd.play()
		if $Petzi2D.flip_h :
			animator.play("kick_attack_R")
		else:
			animator.play("kick_attack_L")
	
	if Input.is_action_just_pressed(btn_attack_2) and animator.current_animation != "kick_attack_R" and animator.current_animation != "kick_attack_L":
		$petziUppercut_snd.play()
		if $Petzi2D.flip_h:
			animator.play("uppercut_R")
		else:
			animator.play("uppercut_L")
	
	game_status()
	move_and_slide()
	lifeStatus()
