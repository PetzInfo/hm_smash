extends Node2D

var osterei = 0

var p1 : int = 0
var p2 : int = 1

func _process(_delta):
	if osterei == 10 or osterei == -10:
		$osterei.show()
		await get_tree().create_timer(0.25).timeout
		$osterei.hide()
		osterei = 0

		
	
	match p1:
		0:
			get_node("player_1").play("char_david")
			$p1_selected_char.text = "David"
		1:
			get_node("player_1").play("char_petzi")
			$p1_selected_char.text = "Petzi"
		2:
			get_node("player_1").play("char_theo")
			$p1_selected_char.text = "Theo"
		3:
			get_node("player_1").play("char_flo")
			$p1_selected_char.text = "Flo"
		
	
	match p2:
		0:
			get_node("player_2").play("char_david")
			$p2_selected_char.text = "David"
		1:
			get_node("player_2").play("char_petzi")
			$p2_selected_char.text = "Petzi"
			
		2:
			get_node("player_2").play("char_theo")
			$p2_selected_char.text = "Theo"
		3:
			get_node("player_2").play("char_flo")
			$p2_selected_char.text = "Flo"
		
	


func _on_p_1_left_btn_pressed():
	osterei -= 1
	if p1 > 0:
		p1 -= 1
		CharacterSelectionManager.player_1_choice = p1
		$click_snd.play()
		await $click_snd.finished


func _on_p_1_right_btn_pressed():
	osterei += 1
	if p1 < 3:
		p1 += 1
		CharacterSelectionManager.player_1_choice = p1
		$click_snd.play()
		await $click_snd.finished


func _on_p_2_left_btn_pressed():
	osterei -= 1
	if p2 > 0:
		p2 -= 1
		CharacterSelectionManager.player_2_choice = p2
		$click_snd.play()
		await $click_snd.finished

func _on_p_2_right_btn_pressed():
	osterei += 1
	if p2 < 3:
		p2 += 1
		CharacterSelectionManager.player_2_choice = p2
		$click_snd.play()
		await $click_snd.finished


func _on_next_pressed():
	$click_snd.play()
	await $click_snd.finished
	Game.choosenPlayer_1_packed = CharacterSelectionManager.selectableCharacters[p1]
	Game.choosenPlayer_2_packed = CharacterSelectionManager.selectableCharacters[p2]
	get_tree().change_scene_to_file("res://ui/map_selection/map_selection.tscn")


func _on_back_pressed():
	$click_snd.play()
	await $click_snd.finished
	get_tree().change_scene_to_file("res://ui/startbildschirm/start_screen.tscn")
	
	
	
