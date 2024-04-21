extends Control


var progress = [0]
var progress_auxiliar = []
var scene_load_status = 0
var scenes_to_load_path = ["res://Scenes/main_room.tscn", "res://Scenes/normal_room.tscn",
"res://Scenes/loot_room.tscn", "res://Scenes/key_room.tscn", "res://Scenes/dead_end.tscn", "res://Scenes/boss_room.tscn"]
var new_scene

func _ready():
	for i in scenes_to_load_path:
		ResourceLoader.load_threaded_request(i)


func _process(delta):
	for i in scenes_to_load_path:
		scene_load_status = ResourceLoader.load_threaded_get_status(i, progress_auxiliar)
		progress[0] += progress_auxiliar[0] 
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			RoomInformationGlobal.main_room_scene
			new_scene = ResourceLoader.load_threaded_get(i)
			if i.find("main_room") != -1:
				RoomInformationGlobal.main_room_scene = new_scene
			elif i.find("normal_room") != -1:
				RoomInformationGlobal.normal_room_scene = new_scene
			elif i.find("loot_room") != -1:
				RoomInformationGlobal.loot_room_scene = new_scene
			elif i.find("key_room") != -1:
				RoomInformationGlobal.key_room_scene = new_scene
			elif i.find("dead_end") != -1:
				RoomInformationGlobal.dead_end_scene = new_scene
			elif i.find("boss_room") != -1:
				RoomInformationGlobal.boss_room_scene = new_scene
			
			var scene_index = scenes_to_load_path.find(i)
			if scene_index != -1:
				scenes_to_load_path.remove_at(scene_index)
				
	progress[0] /= scenes_to_load_path.size()
	
	$PercentageLabel.text = str(min(floor(progress[0]*100),100)) + "%"
	progress[0] = 0
	if scenes_to_load_path.size() == 0:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
