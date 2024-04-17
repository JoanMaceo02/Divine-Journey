extends Node2D


@onready var room_scene = preload("res://Scenes/main_room.tscn")
@onready var room = preload("res://Scripts/main_room.gd")
@onready var room_connection = preload("res://Scenes/connection.tscn")

var min_number_rooms = 10
var max_number_rooms = 10

# List of the rooms of the dungeon 
@export var dungeon = []
var isBossRoomPlaced = false
var isKeyRoomPlaced = false


func _ready():
	generate_dungeon(randi_range(-1000, 1000))
	place_new_room(dungeon[0])
	#load_map()

func generate_dungeon(dungeon_seed):
	seed(dungeon_seed)
	var dungeon_size = randi_range(min_number_rooms, max_number_rooms)
	
	# Reference to the script attached to the scene
	var main_room = room.new()
	main_room.room_type = "Main Room"
	dungeon.append(main_room)
	
	for i in dungeon:
		if dungeon_size > 0:
			if not i.is_room_checked and i.room_type != "Dead End" and i.room_type != "Boss Room":
				i.is_room_checked = true
				var directions = select_directions()
				for x in directions:
					var new_room = null
					if x == 1: # Up
						if i.connected_rooms[Vector2(0,1)] == null and i.room_connections < 3:
							new_room = create_new_room(dungeon_size)
							connect_rooms(i, new_room, x)
							dungeon.append(new_room)
							dungeon_size -= 1
					elif x == 2: # Right
						if i.connected_rooms[Vector2(1,0)] == null and i.room_connections < 3:
							new_room = create_new_room(dungeon_size)
							connect_rooms(i, new_room, x)
							dungeon.append(new_room)
							dungeon_size -= 1
					elif x == 3: # Down
						if i.connected_rooms[Vector2(0,-1)] == null and i.room_connections < 3:
							new_room = create_new_room(dungeon_size)
							connect_rooms(i, new_room, x)
							dungeon.append(new_room)
							dungeon_size -= 1
					elif x == 4: # Left
						if i.connected_rooms[Vector2(-1,0)] == null and i.room_connections < 3:
							new_room = create_new_room(dungeon_size)
							connect_rooms(i, new_room, x)
							dungeon.append(new_room)
							dungeon_size -= 1



func connect_rooms(room1, room2, direction):
	if direction == 1: # Up
		room1.connected_rooms[Vector2(0,1)] = room2
		room2.connected_rooms[Vector2(0,-1)] = room1
	elif direction == 2: # Right
		room1.connected_rooms[Vector2(1,0)] = room2
		room2.connected_rooms[Vector2(-1,0)] = room1
	elif direction == 3: # Down
		room1.connected_rooms[Vector2(0,-1)] = room2
		room2.connected_rooms[Vector2(0,1)] = room1
	elif direction == 4: # Left
		room1.connected_rooms[Vector2(-1,0)] = room2
		room2.connected_rooms[Vector2(1,0)] = room1
	
	room1.room_connections += 1
	room2.room_connections += 1


func select_directions():
	# 1 up, 2, right, 3, down, 4 left
	var direction_list = [1,2,3,4]
	var selected_direction = []
	# We select 3 direction
	for i in range(3):
		var direction_index = randi_range(0, direction_list.size() - 1)
		selected_direction.append(direction_list[direction_index])
		direction_list.remove_at(direction_index)

	return selected_direction


# This function creates a room 
func create_new_room(dungeon_size):
	var room_types = ["Normal Room", "Loot Room", "Boss Room", "Key Room", "Dead End"]
	# We checked if there is already a Loot Room or a Boss Room
	if isBossRoomPlaced:
		var bossRoomIndex = room_types.find("Boss Room")
		# Find returns -1 if element not in list
		if bossRoomIndex != -1:
			room_types.remove_at(bossRoomIndex)
	
	if isKeyRoomPlaced:
		var keyRoomIndex = room_types.find("Key Room")
		# Find returns -1 if element not in list
		if keyRoomIndex != -1:
			room_types.remove_at(keyRoomIndex)
	
	var new_room = room.new()
	
	# Check to guarantee that there is a Boss Room and a Key Room
	if dungeon_size == 2 and not isBossRoomPlaced and not isKeyRoomPlaced:
		room_types = ["Boss Room", "Key Room"]
		var type_index = randi_range(0, room_types.size() - 1)
		new_room.room_type = room_types[type_index]
		room_types.remove_at(type_index)
	elif dungeon_size == 1 and not isBossRoomPlaced:
		new_room.room_type = "Boss Room"
		isBossRoomPlaced = true
	elif dungeon_size == 1 and not isKeyRoomPlaced:
		new_room.room_type = "Key Room"
		isKeyRoomPlaced = true
	else:
		var type_index = randi_range(0, room_types.size() - 1)
		if room_types[type_index] == "Boss Room" and not isBossRoomPlaced:
			isBossRoomPlaced = true
		
		if room_types[type_index] == "Key Room" and not isKeyRoomPlaced:
			isKeyRoomPlaced = true
		new_room.room_type = room_types[type_index]
	
	return new_room


func place_new_room(script):
	print(script.room_type)
	var main_room_scene = room_scene.instantiate()
	main_room_scene.change_room_values(script)
	add_child(main_room_scene)
	

# Fucntion to show the map
func load_map():
	for i in dungeon:
		if not i.is_room_placed:
			i.is_room_placed = true
			add_child(i)
		for x in i.connected_rooms.keys():
			var room_to_place = i.connected_rooms[x]
			if room_to_place != null:
				if not room_to_place.is_room_placed:
					add_child(room_to_place)
					room_to_place.global_position += x * 250 + i.global_position
					var new_connection = room_connection.instantiate()
					add_child(new_connection)
					new_connection.global_position = x * 200 + i.global_position
					if x == Vector2(1,0):
						new_connection.global_position += Vector2(-3,50)
					elif x == Vector2(-1, 0):
						new_connection.global_position += Vector2(147,50)
					elif x == Vector2(0,1):
						new_connection.rotation_degrees = 90
						new_connection.global_position += Vector2(110,-60)
						room_to_place.global_position += Vector2(0, -50)
					elif x == Vector2(0,-1):
						new_connection.rotation_degrees = 90
						new_connection.global_position += Vector2(110,140)
						room_to_place.global_position += Vector2(0, 50)
