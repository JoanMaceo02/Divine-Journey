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


# This function may be updated in the future
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


func take_damage(damageRecivied):
	take_damage_signal.emit(damageRecivied)
	health -= damageRecivied
	healthbar.health = health
	
	hit_flash_anim_player.play("hit_flash")
	if health <= 0:
		die()


func die():
	# We go to main menu for the time being when we die
	var menu_level = load("res://Scenes/main_menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(menu_level)


func _on_hurt_box_area_entered(area):
	take_damage(area.get_parent().get_parent().damage)
	
