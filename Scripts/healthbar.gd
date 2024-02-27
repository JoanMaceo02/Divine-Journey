extends ProgressBar


@onready var timer = $Timer
# The damage bar is the second progress bar that creates the white effect when a character takes damage
@onready var damage_bar = $DamageBar

# The function _set_health will be called each time the health value changes
var health = 0 : set = _set_health


func _set_health(new_health):
	var prev_health = health
	health = new_health
	# The value of the progress bar
	value = health
	
	# We eliminate the health bar if health goes below 0 or is equal to 0
	if health <= 0:
		queue_free()
	
	# We activate the timer for the delay activation of the damage bar effect
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	

# When the timer reaches 0 we set the damage bar value to the health value
func _on_timer_timeout():
	damage_bar.value = health
