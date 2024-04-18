extends Node2D

@onready var generate_button = $Generate


func _ready():
	generate_button.button_down.connect(_on_generate_pressed)



func _on_generate_pressed():
	var menu = load("res://Scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(menu)
