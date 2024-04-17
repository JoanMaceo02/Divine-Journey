extends RoomBase

#@onready var player = get_parent().get_node("Player") # Player variable
@onready var room_scene = preload("res://Scenes/main_room.tscn")
var new_script = null


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.position = $PlayerSpawnPoint.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = room_type


func change_room(new_room):
	RoomInformationGlobal.script_current_room = new_room
	get_tree().change_scene_to_packed(room_scene)


func _on_tree_entered():
	if RoomInformationGlobal.script_current_room != null:
		change_room_values(RoomInformationGlobal.script_current_room)
