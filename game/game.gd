extends Node

var pause_menu_instance
var game_started = false
var game_over = false
var is_game_paused = false
var winner = 0

var choosenPlayer_1_packed
var choosenPlayer_2_packed 
var player_1_instance
var player_2_instance 
var c_map_packed
var map_instance
var music_player


var power = 300
var gravity = 5000 
var acceleration = 250
var max_speed = 500
var jump_force = 1500
var p1_hits = 0
var p2_hits = 0
var lifes_p1 = 3
var lifes_p2 = 3


func play_music():
	music_player = AudioStreamPlayer.new()
	music_player.set_bus("music")
	add_child(music_player)
	music_player.stream = Preloads.music_packed
	

func add_hit(id):
	if id == 1:
		p2_hits += 1
	else:
		p1_hits += 1

func playerstats():
	var lifedisplay_instance = Preloads.lifedisplay_packed.instantiate()
	var powerbar_instance = Preloads.powerbar_packed.instantiate()
	map_instance.add_child(lifedisplay_instance)
	map_instance.add_child(powerbar_instance)

func pause_game():
	is_game_paused = true
	acceleration = 0
	jump_force = 0
	
func resume_game():
	is_game_paused = false
	acceleration = 250
	jump_force = 1500
	
func reset():
	lifes_p1 = 3
	lifes_p2 = 3
	p1_hits = 0
	p1_hits = 0
	power = 300
	acceleration = 250

func countdown():
	pause_game()
	var countdown_instance = Preloads.countdown_packed.instantiate()
	map_instance.add_child(countdown_instance)
	
func show_winner():
	if game_over:
		return
	game_over = true
	game_started = false
	map_instance.queue_free()
	var win_screen_instance = Preloads.winning_screen_packed.instantiate()
	get_tree().get_root().add_child(win_screen_instance)
	
func load_pausemenu():
	pause_menu_instance = Preloads.pause_menu_packed.instantiate()
	map_instance.add_child(pause_menu_instance)

func load_choosen_map():
	c_map_packed = MapSelectionManager.choosen_map
	map_instance = c_map_packed.instantiate()
	get_tree().get_root().add_child(map_instance)

func load_p1():
	player_1_instance = choosenPlayer_1_packed.instantiate()
	player_1_instance.set_id(1)
	player_1_instance.set_moves("p1_left", "p1_right", "p1_jump", "p1_attack_1", "p1_attack_2")
	player_1_instance.position.x = 543
	player_1_instance.position.y = 250	
	return player_1_instance
	
func spawn_p1():
	p2_hits = 0
	map_instance.add_child(load_p1())
	
func load_p2():
	player_2_instance = choosenPlayer_2_packed.instantiate()
	player_2_instance.set_id(2)
	player_2_instance.set_moves("p2_left", "p2_right", "p2_jump", "p2_attack_1", "p2_attack_2")
	player_2_instance.position.x = 1394
	player_2_instance.position.y = 250
	return player_2_instance
	
func spawn_p2():
	p1_hits = 0
	map_instance.add_child(load_p2())

func start_match():
	
	load_choosen_map()
	load_pausemenu()
	spawn_p1()
	spawn_p2()
	playerstats()
	countdown()
	
func respawn(identification):
	if identification == 1:
		lifes_p1 -= 1
		print("P1 lifes: " + str(lifes_p1))
		if lifes_p1 > 0:
			spawn_p1()
		else:
			print("P1 is dead")
	if identification == 2:
		lifes_p2 -= 1
		print("P2 lifes: " + str(lifes_p2))
		if lifes_p2 > 0:
			spawn_p2()
		else:
			print("P2 is dead")

func _ready():
	play_music()

func _process(_delta):
	
	music_player.set_volume_db(0.1)
	print(music_player.playing)
	
	if !music_player.playing:
		music_player.play()
		
			
	if is_game_paused:
		return
	
	if lifes_p1 == 0:
		winner = 2
		show_winner()
		
	elif lifes_p2 == 0:
		winner = 1
		show_winner()
