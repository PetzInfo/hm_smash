extends CanvasLayer


var winner = Game.winner


func _on_restart_btn_pressed():
	Game.reset()
	Game.game_over = false
	get_tree().change_scene_to_file("res://ui/character_selection/character_selection.tscn")
	queue_free()

func _process(_delta):
	if winner == 1:
		$player.play("player1")
	else:
		$player.play("player2")
