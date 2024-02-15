extends Control



func _on_back_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	get_tree().change_scene_to_file("res://ui/character_selection/character_selection.tscn")


func _on_next_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	if MapSelectionManager.choosen_map == null:
		MapSelectionManager.setMap("FK12")
	Game.start_match()
	queue_free()
	


func _on_rbau_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	MapSelectionManager.setMap("rbau")
	$choosen_check.position.x = 1097


func _on_mucdai_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	MapSelectionManager.setMap("mucdai")
	$choosen_check.position.x = 514


func _on_fk_12_btn_pressed():
	$click_snd.play()
	await $click_snd.finished
	MapSelectionManager.setMap("FK12") 
	$choosen_check.position.x = 1671
	

