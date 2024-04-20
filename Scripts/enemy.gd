extends CharacterBody2D

# Stats
@export var speed = 100
@export var health = 100
@export var damage = 20

var is_attacking = false
var direction = Vector2.ZERO

@onready var animation_tree = $AnimationTree
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var popupPosition = $PopupLocation
@onready var healthbar = $Healthbar
@onready var player = get_parent().get_node("Player")

# Signals
signal take_damage_signal(damageRecieved)
signal enemy_die


func _ready():
	# We init the healthbar at the start of the scene
	healthbar.init_health(health)


func _physics_process(delta):
	move_enemy(delta)


func move_enemy(delta):
	# distance and direction of the enemy from the player
	var distance = (player.position - position)
	direction = distance.normalized()
	
	# Valor provisional para que se detenga el enemigo, cambiar mas adelante
	if not is_attacking:
		if (distance.length() < 100):
			velocity = Vector2.ZERO
			is_attacking = true
		else:
			velocity = direction * speed
		
		# We only update the blend positions if the player is not attacking
		update_blend_position()
	
	# Setters of values for the animation tree
	set_attacking_value()
	set_walking_value()
	
	move_and_slide()


func update_blend_position():
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/Attack/blend_position"] = direction


func set_walking_value():
	animation_tree["parameters/conditions/is_walking"] = not is_attacking


func set_attacking_value():
	animation_tree["parameters/conditions/is_attacking"] = is_attacking


# Function to take damage
func take_damage(damageRecivied):
	take_damage_signal.emit(damageRecivied)
	health -= damageRecivied
	healthbar.health = health
	
	hit_flash_anim_player.play("hit_flash")
	if health <= 0:
		die()


func die():
	var room = get_parent()
	room.enemies_count -= 1
	queue_free()


func _on_hurt_box_area_entered(area):
	take_damage(player.damage)
