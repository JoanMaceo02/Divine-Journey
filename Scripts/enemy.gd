extends CharacterBody2D


@export var speed = 100
var direction = Vector2.ZERO
var is_attacking = false

@onready var player = get_parent().get_node("Player")
@onready var animation_tree = $AnimationTree


func _physics_process(delta):
	move_enemy(delta)
	print((player.position - position).length())


func move_enemy(delta):
	# distance and direction of the enemy from the player
	var distance = (player.position - position)
	direction = distance.normalized()
	
	# Valor provisional para que se detenga el enemigo, cambiar mas adelante
	if (distance.length() < 70):
		velocity = Vector2.ZERO
		is_attacking = true
	else:
		velocity = direction * speed
		is_attacking = false
	
	
	set_attacking_value()
	set_walking_value()
	update_blend_position()
	move_and_slide()


func update_blend_position():
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/Attack/blend_position"] = direction


func set_walking_value():
	animation_tree["parameters/conditions/is_walking"] = not is_attacking


func set_attacking_value():
	animation_tree["parameters/conditions/is_attacking"] = is_attacking
