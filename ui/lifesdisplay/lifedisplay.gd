extends CanvasLayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var lifesP1 = Game.lifes_p1
	var lifesP2 = Game.lifes_p2
	
	match lifesP1:
		3:
			$lifesP1.play("3")
		2:
			$lifesP1.play("2")
		1:
			$lifesP1.play("1")
		0:
			$lifesP1.play("0")
			
	match lifesP2:
		3:
			$lifesP2.play("3")
		2:
			$lifesP2.play("2")
		1:
			$lifesP2.play("1")
		0:
			$lifesP2.play("0")
