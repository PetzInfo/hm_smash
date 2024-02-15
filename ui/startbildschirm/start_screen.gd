extends Node2D


func _on_play_btn_pressed():
	$click.play()
	await $click.finished
	get_tree().change_scene_to_file("res://ui/character_selection/character_selection.tscn")

func _on_quit_btn_pressed():
	$click.play()
	await $click.finished
	get_tree().quit()
