extends CanvasLayer

var is_paused = false

func _on_pause_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	Game.pause_game()
	is_paused = true

func _on_resume_pressed():
	$click_snd.play()
	await $click_snd.finished
	Game.resume_game()
	is_paused = false
	
func _on_exit_pressed():
	$click_snd.play()
	await $click_snd.finished
	Game.player_1_instance.queue_free()
	Game.player_2_instance.queue_free()
	Game.map_instance.queue_free()
	Game.pause_menu_instance.queue_free()
	get_tree().change_scene_to_file("res://ui/character_selection/character_selection.tscn")

func _process(_delta):
	if !is_paused:
		$pause_btn.show()
		$resume.hide()
		$exit.hide()
		$menu_shadow.hide()
		
	else:
		$pause_btn.hide()
		$resume.show()
		$exit.show()
		$menu_shadow.show()
	
