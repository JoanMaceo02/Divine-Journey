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
@onready var fps_label = $CanvasLayer/FPS

#Signals
signal take_damage_signal(damageRecieved)


func _ready():
	# We init the healthbar at the start of the scene
	healthbar.init_health(health)

func _physics_process(delta):
	player_movement(delta)
	fps_label.text = str(Engine.get_frames_per_second())


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


# Used to change scene when the player enters a door 
func _on_detect_door_body_entered(body):
	var parent_node = body.get_parent()
	if body.get_name() == "DoorLeft":
		if parent_node.connected_rooms[Vector2(-1, 0)] != null:
			var new_room = parent_node.connected_rooms[Vector2(-1, 0)]
			# We save the new information of the current room 
			parent_node.update_room_information(new_room.connected_rooms[Vector2(1, 0)])
			var direction = 1
			body.get_parent().change_room(new_room, direction)
			
	elif body.get_name() == "DoorRight":
		if parent_node.connected_rooms[Vector2(1, 0)] != null:
			var new_room = parent_node.connected_rooms[Vector2(1, 0)]
			parent_node.update_room_information(new_room.connected_rooms[Vector2(-1, 0)])
			var direction = 2
			body.get_parent().change_room(new_room, direction)
		
	elif body.get_name() == "DoorUp":
		if parent_node.connected_rooms[Vector2(0, 1)] != null:
			var new_room = parent_node.connected_rooms[Vector2(0, 1)]
			parent_node.update_room_information(new_room.connected_rooms[Vector2(0, -1)])
			var direction = 3
			body.get_parent().change_room(new_room, direction)
			
	elif body.get_name() == "DoorDown":
		if parent_node.connected_rooms[Vector2(0, -1)] != null:
			var new_room = parent_node.connected_rooms[Vector2(0, -1)]
			parent_node.update_room_information(new_room.connected_rooms[Vector2(0, 1)])
			var direction = 4
			body.get_parent().change_room(new_room, direction)


func _on_tree_entered():
	if PlayerVariables.player_spawn_position != null:
		position = PlayerVariables.player_spawn_position
