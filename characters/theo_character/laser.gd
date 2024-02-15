extends Sprite2D

@export var Speed = 500


var direction

func ready():
	$".".scale(0.01, 0.01)


func _physics_process(delta):
	if direction == 1:
		global_position.x += Speed * delta
	else: 
		$".".flip_h = true
		global_position.x -= Speed * delta
		

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	

func _on_area_2d_body_entered(body):
		if body != self and body.has_method("handle_hit"):
			body.handle_hit(direction)
			queue_free()
		
