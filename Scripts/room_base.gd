class_name RoomBase
extends Node2D


@onready var type_Label = $Label

# Variable that says which type is the room
var room_type = ""
# Variable to help show the dungeon visually
var is_room_placed = false
var is_room_checked = false
var room_connections = 0
var enemies_count = null

# Four posible connections, right, left, up, down
var connected_rooms = {
	Vector2(1, 0): null,
	Vector2(-1, 0): null,
	Vector2(0, 1): null,
	Vector2(0, -1): null
}

func _process(delta):
	type_Label.text = room_type


func change_room(new_room, direction):
	RoomInformationGlobal.script_current_room = new_room
	RoomInformationGlobal.entry_direction = direction
	if new_room.room_type == "Main Room":
		SceneTransition.change_scene(RoomInformationGlobal.main_room_scene)
	elif new_room.room_type == "Normal Room":
		SceneTransition.change_scene(RoomInformationGlobal.normal_room_scene)
	elif new_room.room_type == "Loot Room":
		SceneTransition.change_scene(RoomInformationGlobal.loot_room_scene)
	elif new_room.room_type == "Key Room":
		SceneTransition.change_scene(RoomInformationGlobal.key_room_scene)
	elif new_room.room_type == "Dead End":
		SceneTransition.change_scene(RoomInformationGlobal.dead_end_scene)
	elif new_room.room_type == "Boss Room":
		SceneTransition.change_scene(RoomInformationGlobal.boss_room_scene)


func change_room_values(script_new_values):
	room_type = script_new_values.room_type
	is_room_placed = script_new_values.is_room_placed
	is_room_checked = script_new_values.is_room_checked
	room_connections = script_new_values.room_connections
	connected_rooms = script_new_values.connected_rooms
	enemies_count = script_new_values.enemies_count
	
	if RoomInformationGlobal.entry_direction != null:
		if RoomInformationGlobal.entry_direction == 1:
			PlayerVariables.player_spawn_position = get_node("PlayerSpawnPointRight").position
		elif RoomInformationGlobal.entry_direction == 2:
			PlayerVariables.player_spawn_position = get_node("PlayerSpawnPointLeft").position
		elif RoomInformationGlobal.entry_direction == 3:
			PlayerVariables.player_spawn_position = get_node("PlayerSpawnPointDown").position
		elif RoomInformationGlobal.entry_direction == 4:
			PlayerVariables.player_spawn_position = get_node("PlayerSpawnPointUp").position
	else:
		PlayerVariables.player_spawn_position = get_node("PlayerSpawnPoint").position
	var player_scene = load("res://Scenes/player.tscn")
	add_child(player_scene.instantiate())


func spawn_enemies():
	if enemies_count != null:
		for i in range(enemies_count):
			var enemy_scene = load("res://Scenes/enemy.tscn").instantiate()
			add_child(enemy_scene)
			enemy_scene.position = get_node("EnemySpawnPoint").position


func update_room_information(room_script):
	room_script.enemies_count = enemies_count
