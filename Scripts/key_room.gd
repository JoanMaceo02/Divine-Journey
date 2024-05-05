extends RoomBase

#@onready var player = get_parent().get_node("Player") # Player variable

var new_script = null
var doors_unlocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnStartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = room_type
	
	if enemies_count <= 0 and not doors_unlocked:
		doors_unlocked = true
		#unlock_doors()
		$DoorRight.tile_set.set_physics_layer_collision_layer(0, 32)
		$DoorLeft.tile_set.set_physics_layer_collision_layer(0, 32)
		$DoorUp.tile_set.set_physics_layer_collision_layer(0, 32)
		$DoorDown.tile_set.set_physics_layer_collision_layer(0, 32)


func _on_tree_entered():
	if RoomInformationGlobal.script_current_room != null:
		change_room_values(RoomInformationGlobal.script_current_room)
	if enemies_count > 0:
		$DoorLeft.tile_set.set_physics_layer_collision_layer(0, 16)
		$DoorRight.tile_set.set_physics_layer_collision_layer(0, 16)
		$DoorDown.tile_set.set_physics_layer_collision_layer(0, 16)
		$DoorUp.tile_set.set_physics_layer_collision_layer(0, 16)
	else:
		doors_unlocked = true



func _on_enemy_spawn_start_timer_timeout():
	spawn_enemies()


func unlock_doors():
	if connected_rooms[Vector2(1,0)] != null:
		$DoorRight.tile_set.set_physics_layer_collision_layer(0, 32)
		print("doors unlocked right")
	else:
		$DoorRight.tile_set.set_physics_layer_collision_layer(0, 16)
	
	if connected_rooms[Vector2(-1,0)] != null:
		$DoorLeft.tile_set.set_physics_layer_collision_layer(0, 32)
		print("doors unlocked left")
	else:
		$DoorLeft.tile_set.set_physics_layer_collision_layer(0, 16)
	
	if connected_rooms[Vector2(0,1)] != null:
		$DoorUp.tile_set.set_physics_layer_collision_layer(0, 32)
		print("doors unlocked up")
	else:
		$DoorUp.tile_set.set_physics_layer_collision_layer(0, 16)
	
	if connected_rooms[Vector2(0,-1)] != null:
		$DoorDown.tile_set.set_physics_layer_collision_layer(0, 32)
		print("doors unlocked down")
	else:
		$DoorDown.tile_set.set_physics_layer_collision_layer(0, 16)
