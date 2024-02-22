extends CharacterBody2D

# Stats
@export var speed = 100
@export var health = 300
@export var damage = 20

var is_attacking = false
var direction = Vector2.ZERO

@onready var player = get_parent().get_node("Player")
@onready var animation_tree = $AnimationTree
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var popupPosition = $PopupLocation
@onready var healthbar = $Healthbar

# Signals
signal take_damage_signal(damageRecieved)


func _ready():
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
			
		update_blend_position()
	
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
	queue_free()


func _on_hurt_box_area_entered(area):
	take_damage(player.damage)
