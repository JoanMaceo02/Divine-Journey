extends CharacterBody2D

@export var speed = 300
var current_dir = "none"
@export var health = 100

var input = Vector2.ZERO
@export var is_attacking = false
var is_walking = false

@onready var animation_tree = $AnimationTree
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer

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
	# All the logic for the first basic attack (My idea is to have a basic combo attack for each weapon
	if not is_attacking:
		handle_first_basic_attack()
	
	input = get_input()
	
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


# This function may be updated in teh future
func handle_first_basic_attack():
	is_attacking = Input.is_action_just_pressed("basic_attack")


func set_conditions_value():
	var value_walking = is_walking and not is_attacking
	var value_idle = not is_walking and not is_attacking
	animation_tree["parameters/conditions/is_walking"] = value_walking
	animation_tree["parameters/conditions/idle"] = value_idle
	animation_tree["parameters/conditions/is_attacking"] = is_attacking

func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
	animation_tree["parameters/Attack/blend_position"] = input


func take_damage():
	health -= 50
	print(health)
	hit_flash_anim_player.play("hit_flash")


func _on_hurt_box_area_entered(area):
	take_damage()

