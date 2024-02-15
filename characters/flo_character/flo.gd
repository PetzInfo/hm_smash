extends CharacterBody2D

var id 

@onready var animator = $AnimFlo

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
		$flo_hurt.play()
		await $flo_hurt.finished
		queue_free()
		Game.respawn(id)

func respawn():
	position.x = 960
	position.y = 154
	await get_tree().create_timer(3.0).timeout
	velocity.x = 0
	velocity.y = 0
	knockback_power = 300
	

func _on_attack_2_body_entered(body):
	print("Flo hit objekt area")
	if body != self and body.has_method("handle_hit"):
		body.handle_hit(direction)
		
func _on_attack_1_body_entered(body):
	print("Flo hit objekt area")
	if body != self and body.has_method("handle_hit"):
		body.handle_hit(direction)

func handle_hit(dir):
	$flo_hurt2.play()
	print("Flo handles hit " + str(knockback_power))
	knockback_power += 300
	Game.add_hit(id)
	knockback(dir)

func knockback(dir):
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
	
	velocity.y += gravity * delta
	
	if $Flo2D.flip_h == false:
		direction = -1
	else:
		direction = 1
	
	var is_attacking = animator.current_animation == "attack_2_right" or animator.current_animation == "attack_2_left" or animator.current_animation == "attack_1_left" or animator.current_animation == "attack_1_right"
	
	if Input.is_action_pressed(btn_left) and not is_attacking:	
		animator.play("run")
		$Flo2D.flip_h = false
		if velocity.x > -1000:
			velocity.x -= acceleration
		
	elif Input.is_action_pressed(btn_right) and not is_attacking:
		animator.play("run")
		$Flo2D.flip_h = true
		if velocity.x < 1000:
			velocity.x += acceleration

	elif Input.is_action_just_released(btn_left) or Input.is_action_just_released(btn_right):
		velocity.x = 0
		
		
	if not is_attacking and animator.current_animation != "run" and animator.current_animation != "attack_2_right" and animator.current_animation != "attack_2_left" and animator.current_animation != "jump_floor":
		animator.play("idle")
	
	if is_on_floor():
		jump_count = 0
	
	if ! is_on_floor() and not is_attacking:
		animator.play("jump_air")
		
	if jump_count < max_jumps and Input.is_action_just_pressed(btn_jump):
		$flo_jump.play()
		velocity.y = -jump_force
		jump_count += 1

	if Input.is_action_just_pressed(btn_base_attack) and animator.current_animation != "attack_1_left" and animator.current_animation != "attack_1_right":
		if !$Flo2D.flip_h:
			animator.play("attack_2_left")
		else:
			animator.play("attack_2_right")
			
			
	if Input.is_action_just_pressed(btn_attack_2) and animator.current_animation != "attack_2_left" and animator.current_animation != "attack_2_right":
		$pickaxe.play()
		if !$Flo2D.flip_h:
			animator.play("attack_1_left")
		else:
			animator.play("attack_1_right")
		
	game_status()
	move_and_slide()
	lifeStatus()
