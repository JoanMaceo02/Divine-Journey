extends RoomBase

#@onready var player = get_parent().get_node("Player") # Player variable

var new_script = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnStartTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = room_type



func _on_tree_entered():
	if RoomInformationGlobal.script_current_room != null:
		change_room_values(RoomInformationGlobal.script_current_room)


func _on_enemy_spawn_start_timer_timeout():
	spawn_enemies()
