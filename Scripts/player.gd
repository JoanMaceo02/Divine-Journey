extends CharacterBody2D


# Stats
@export var speed = 300
@export var health = 100
@export var damage = 20

var current_dir = "none"
var input = Vector2.ZERO
var is_attacking = false
var is_walking = false

@onready var animation_tree = $AnimationTree
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var popupPosition = $PopupLocation
@onready var attackTimer = $AttackTimer
@onready var healthbar = $CanvasLayer/Healthbar

#Signals
signal take_damage_signal(damageRecieved)


func _ready():
	# We init the healthbar at the start of the scene
	healthbar.init_health(health)

func _physics_process(delta):
	player_movement(delta)


func get_input():
	# -1 is left 1 is right
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	# -1 is up 1 is down
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	# Normalizar el input para que al apretar dos botones a la vez no vaya más rápido
	return input.normalized()


func player_movement(delta):
	# All the logic for the first basic attack (The idea is to have a basic combo attack for each weapon)
	attack_combo()
	
	# Get the input from the player
	input = get_input()
	
	# if no input is provided the player stops
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
		is_walking = false
	
	else:
		velocity = input * speed
		is_walking = true
		
		# We only update the blend position when walking and not attacking
		if not is_attacking:
			update_blend_position()
	
	set_conditions_value()
	move_and_slide()


# This function must be updated in the future
func attack_combo():
	if Input.is_action_just_pressed("basic_attack"):
		is_attacking = true


func set_conditions_value():
	var value_walking = is_walking 
	var value_idle = not is_walking 
	animation_tree["parameters/conditions/is_walking"] = value_walking
	animation_tree["parameters/conditions/idle"] = value_idle
	animation_tree["parameters/conditions/not_attacking"] = not is_attacking
	animation_tree["parameters/conditions/is_attacking"] = is_attacking

func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
	animation_tree["parameters/Attack/blend_position"] = input


# This function controls the behaviour of the player when taking damage
func take_damage(damageRecivied):
	take_damage_signal.emit(damageRecivied)
	health -= damageRecivied
	healthbar.health = health
	
	# Play the hit flash effect
	hit_flash_anim_player.play("hit_flash")
	if health <= 0:
		die()

# Function that manages the process when the player dies
func die():
	# We go to main menu for the time being when we die
	var menu_level = load("res://Scenes/main_menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(menu_level)


# Used to detect if player is being damaged
func _on_hurt_box_area_entered(area):
	take_damage(area.get_parent().get_parent().damage)


# Function to get the current visible scene
func get_active_room(dungeon_node):
	# Obtener todos los hijos del nodo
	var rooms = dungeon_node.get_children()

	# Filtrar los hijos visibles
	for room in rooms:
		if room.visible:
			return room

# Used to change scene when the player enters a door 
func _on_detect_door_body_entered(body):
	var parent_node = body.get_parent()
	
	"""print(parent_node.connected_rooms)
	if body.is_in_group("DoorLeft"):
		if parent_node.connected_rooms[Vector2(-1, 0)] != null:
			var dungeon_node = get_parent().get_node("Dungeon")
			# Disable the current room
			disable_scene(get_active_room(dungeon_node))
			# Add the next room
			if not dungeon_node.has_node(parent_node.connected_rooms[Vector2(-1, 0)].get_path()):
				dungeon_node.add_child(parent_node.connected_rooms[Vector2(-1, 0)])
			else:
				enable_scene(dungeon_node.get_node(parent_node.connected_rooms[Vector2(-1, 0)].get_path()))
			# Change player position to middle
			var current_room = get_active_room(dungeon_node)
			position = current_room.get_node("PlayerSpawnPoint").position
			print("Scene Changed Left")
			
	elif body.is_in_group("DoorRight"):
		if parent_node.connected_rooms[Vector2(1, 0)] != null:
			var dungeon_node = get_parent().get_node("Dungeon")
			# Disable the current room
			disable_scene(get_active_room(dungeon_node))
			# Add the next room
			if not dungeon_node.has_node(parent_node.connected_rooms[Vector2(1, 0)].get_path()):
				dungeon_node.add_child(parent_node.connected_rooms[Vector2(1, 0)])
			else:
				enable_scene(dungeon_node.get_node(parent_node.connected_rooms[Vector2(1, 0)].get_path()))
			# Change player position to middle
			var current_room = get_active_room(dungeon_node)
			position = current_room.get_node("PlayerSpawnPoint").position
			print("Scene Changed Right")
			
	elif body.is_in_group("DoorUp"):
		if parent_node.connected_rooms[Vector2(0, 1)] != null:
			var dungeon_node = get_parent().get_node("Dungeon")
			# Disable the current room
			disable_scene(get_active_room(dungeon_node))
			# Add the next room
			if not dungeon_node.has_node(parent_node.connected_rooms[Vector2(0, 1)].get_path()):
				dungeon_node.add_child(parent_node.connected_rooms[Vector2(0, 1)])
			else:
				enable_scene(dungeon_node.get_node(parent_node.connected_rooms[Vector2(0, 1)].get_path()))
			# Change player position to middle
			var current_room = get_active_room(dungeon_node)
			position = current_room.get_node("PlayerSpawnPoint").position
			print("Scene Changed Up")
			
	elif body.is_in_group("DoorDown"):
		if parent_node.connected_rooms[Vector2(0, -1)] != null:
			$DetectDoor.monitoring = false
			var dungeon_node = get_parent().get_node("Dungeon")
			# Disable the current room
			disable_scene(get_active_room(dungeon_node))
			# Add the next room
			if not dungeon_node.has_node(parent_node.connected_rooms[Vector2(0, -1)].get_path()):
				dungeon_node.add_child(parent_node.connected_rooms[Vector2(0, -1)])
			else:
				enable_scene(dungeon_node.get_node(parent_node.connected_rooms[Vector2(0, -1)].get_path()))
			# Change player position to middle
			var current_room = get_active_room(dungeon_node)
			position = current_room.get_node("PlayerSpawnPoint").position
			print("Scense Changed Down")
			$DetectDoor.monitoring = true"""


# Función auxiliuar recursiva para obtener el nodo raíz del cuerpo
func get_root_node(node):
	# Verificar si el nodo tiene un padre
	if node.get_parent():
		# Llamar recursivamente a la función con el padre del nodo
		return get_root_node(node.get_parent())
	else:
		# Si el nodo no tiene un padre, es el nodo raíz
		return node


func disable_scene(scene):
	scene.visible = false
	scene.get_node("DoorLeft").tile_set.set_physics_layer_collision_layer(0, 0)
	scene.get_node("DoorRight").tile_set.set_physics_layer_collision_layer(0, 0)
	scene.get_node("DoorUp").tile_set.set_physics_layer_collision_layer(0, 0)
	scene.get_node("DoorDown").tile_set.set_physics_layer_collision_layer(0, 0)

func enable_scene(scene):
	scene.visible = true
	scene.get_node("DoorLeft").tile_set.set_physics_layer_collision_layer(0, 2**5)
	scene.get_node("DoorRight").tile_set.set_physics_layer_collision_layer(0, 2**5)
	scene.get_node("DoorUp").tile_set.set_physics_layer_collision_layer(0, 2**5)
	scene.get_node("DoorDown").tile_set.set_physics_layer_collision_layer(0, 2**5)
