extends Marker2D

var damage_node = preload("res://Scenes/floating_numbers.tscn") 

func _ready():
	randomize()

func popupEnemy(damageRecieved):
	var damage = damage_node.instantiate()
	damage.get_node("Label").text = str(damageRecieved)
	damage.position = global_position
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", global_position + get_direction(), 0.75)
	
	get_tree().current_scene.add_child(damage)


func popupPlayer(damageRecieved):
	var damage = damage_node.instantiate()
	var damage_label = damage.get_node("Label")
	damage_label.text = str(damageRecieved)
	damage_label.modulate = Color(0.992, 0, 0.22)
	
	damage.position = global_position
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", global_position + get_direction(), 0.75)
	
	get_tree().current_scene.add_child(damage)


func get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 16


func _on_enemy_take_damage_signal(damageRecieved):
	popupEnemy(damageRecieved)


func _on_player_take_damage_signal(damageRecieved):
	popupPlayer(damageRecieved)
