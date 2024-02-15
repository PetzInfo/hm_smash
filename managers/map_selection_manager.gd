extends Node

var choosen_map 

var maps = {
	"FK12" : preload("res://maps/NEW_fk12_no_characters/fk_12_map_container.tscn"),
	"mucdai" : preload("res://maps/mucdai/mucdai_container.tscn"),
	"rbau" : preload("res://maps/r_bau/rbau_map_container.tscn")
}

func setMap(mapstr):
	
	choosen_map = maps[mapstr]
