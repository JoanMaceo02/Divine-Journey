class_name MainMenu
extends Node2D



# We read the buttons play and quit as variables
@onready var play_button = $MarginContainer/HBoxContainer/VBoxContainer/PlayButton as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button

# We do preload in order to stored teh scene in memory at the very beginning,
# This is helpful in order to avoid having delay when loading large scene
@onready var start_level = preload("res://Scenes/mainScene.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.button_down.connect(on_start_pressed)
	quit_button.button_down.connect(on_quit_pressed)
	Engine.max_fps = 60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


func on_quit_pressed() -> void:
	get_tree().quit()


func show_fps(delta):
	print(str(Engine.get_frames_per_second()))
