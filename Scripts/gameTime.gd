extends Control

var seconds = 0
var secondsFirstDigit = 0
var secondsSecondDigit = 0
var minutesFirstDigit = 0
var minutesSecondsDigit = 0

@onready var secondsLabelFirstDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Seconds1
@onready var secondsLabelSecondDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Seconds2
@onready var minutesLabelFirstDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Minutes1
@onready var minutesLabelSecondsDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Minutes2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds += delta
	secondsFirstDigit = str(int(seconds) % 10)
	secondsSecondDigit = str((int(seconds) / 10) % 6)
	minutesFirstDigit = str((int(seconds) / 60) % 10)
	minutesSecondsDigit = str(int(seconds) / 600 % 6)
	
	secondsLabelFirstDigit.text = secondsFirstDigit
	secondsLabelSecondDigit.text = secondsSecondDigit
	minutesLabelFirstDigit.text = minutesFirstDigit
	minutesLabelSecondsDigit.text = minutesSecondsDigit
