extends RoomBase

#@onready var player = get_parent().get_node("Player") # Player variable

var new_script = null


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemies()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = room_type


func change_room(new_room):
	RoomInformationGlobal.script_current_room = new_room
	if new_room.room_type == "Main Room":
		var main_room_scene = load("res://Scenes/main_room.tscn")
		get_tree().change_scene_to_packed(main_room_scene)
	elif new_room.room_type == "Normal Room":
		var normal_room_scene = load("res://Scenes/normal_room.tscn")
		get_tree().change_scene_to_packed(normal_room_scene)
	elif new_room.room_type == "Loot Room":
		var loot_room_scene = load("res://Scenes/loot_room.tscn")
		get_tree().change_scene_to_packed(loot_room_scene)
	elif new_room.room_type == "Key Room":
		var key_room_scene = load("res://Scenes/key_room.tscn")
		get_tree().change_scene_to_packed(key_room_scene)
	elif new_room.room_type == "Dead End":
		var dead_end_scene = load("res://Scenes/dead_end.tscn")
		get_tree().change_scene_to_packed(dead_end_scene)
	elif new_room.room_type == "Boss Room":
		var boss_room_scene = load("res://Scenes/boss_room.tscn")
		get_tree().change_scene_to_packed(boss_room_scene)


func _on_tree_entered():
	if RoomInformationGlobal.script_current_room != null:
		change_room_values(RoomInformationGlobal.script_current_room)
