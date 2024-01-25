extends CharacterBody2D

@export var speed = 300
var current_dir = "none"

var input = Vector2.ZERO


func _ready():
	$Sprite2D.play("right_idle")

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
	play_animation(input)
	
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
		
	else:
		velocity = input * speed
		
	move_and_slide()
	

func play_animation(movement):
	var anim = $Sprite2D
	if movement.x > 0:
		current_dir = "right"
		anim.play("right_walk")
	elif movement.x < 0:
		current_dir = "left"
		anim.play("left_walk")
	elif movement.y < 0:
		current_dir = "up"
		anim.play("back_walk")
	elif movement.y > 0:
		current_dir = "down"
		anim.play("front_walk")
	
	# Match es como un switch
	else:
		match current_dir:
			"right":
				anim.play("right_idle")
			"left":
				anim.play("left_idle")
			"up":
				anim.play("back_idle")
			"down":
				anim.play("front_idle")
	

