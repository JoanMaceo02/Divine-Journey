class_name RoomBase
extends Node2D


@onready var type_Label = $Label

# Variable that says which type is the room
var room_type = ""
# Variable to help show the dungeon visually
var is_room_placed = false
var is_room_checked = false
var room_connections = 0

# Four posible connections, right, left, up, down
var connected_rooms = {
	Vector2(1, 0): null,
	Vector2(-1, 0): null,
	Vector2(0, 1): null,
	Vector2(0, -1): null
}

func _process(delta):
	type_Label.text = room_type
