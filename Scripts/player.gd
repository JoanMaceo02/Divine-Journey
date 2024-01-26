extends CharacterBody2D

@export var speed = 300
var current_dir = "none"

var input = Vector2.ZERO

@onready var animation_tree = $AnimationTree

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
	input = get_input()
	
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
		set_walking_value(false)
		
	else:
		velocity = input * speed
		set_walking_value(true)
		# We only update the blend position when walking
		update_blend_position()
		
	move_and_slide()
	


func set_walking_value(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value


func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
