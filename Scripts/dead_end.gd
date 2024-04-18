extends RoomBase

#@onready var player = get_parent().get_node("Player") # Player variable
@onready var main_room_scene = preload("res://Scenes/main_room.tscn")
@onready var normal_room_scene = preload("res://Scenes/normal_room.tscn")
@onready var loot_room_scene = preload("res://Scenes/loot_room.tscn")
@onready var key_room_scene = preload("res://Scenes/key_room.tscn")
@onready var dead_end_scene = preload("res://Scenes/dead_end.tscn")
@onready var boss_room_scene = preload("res://Scenes/boss_room.tscn")
var new_script = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = room_type


func change_room(new_room):
	RoomInformationGlobal.script_current_room = new_room
	if new_room.room_type == "Main Room":
		get_tree().change_scene_to_packed(main_room_scene)
	elif new_room.room_type == "Normal Room":
		get_tree().change_scene_to_packed(normal_room_scene)
	elif new_room.room_type == "Loot Room":
		get_tree().change_scene_to_packed(loot_room_scene)
	elif new_room.room_type == "Key Room":
		get_tree().change_scene_to_packed(key_room_scene)
	elif new_room.room_type == "Dead End":
		get_tree().change_scene_to_packed(dead_end_scene)
	elif new_room.room_type == "Boss Room":
		get_tree().change_scene_to_packed(boss_room_scene)


func _on_tree_entered():
	if RoomInformationGlobal.script_current_room != null:
		change_room_values(RoomInformationGlobal.script_current_room)
