extends Node


var main_room_scene = load("res://Scenes/main_room.tscn")
var normal_room_scene = load("res://Scenes/normal_room.tscn")
var loot_room_scene = load("res://Scenes/loot_room.tscn")
var key_room_scene = load("res://Scenes/key_room.tscn")
var dead_end_scene = load("res://Scenes/dead_end.tscn")
var boss_room_scene = load("res://Scenes/boss_room.tscn")

var script_current_room = null
var entry_direction = null
