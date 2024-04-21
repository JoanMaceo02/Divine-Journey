extends CanvasLayer
var new_scene = null

func change_scene(scene):
	new_scene = scene
	$AnimationPlayer.play("dissolve")
	get_tree().paused = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dissolve":
		get_tree().change_scene_to_packed(new_scene)
		$AnimationPlayer.play("dissolve_backwards")
		get_tree().paused = false
	
