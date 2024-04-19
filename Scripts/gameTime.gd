extends Control

# seconds variable tracks the complete seconds that have elapsed in total
var seconds = 0
# the next four variables are used to set the right text number for each digit of the clock
var secondsFirstDigit = 0
var secondsSecondDigit = 0
var minutesFirstDigit = 0
var minutesSecondsDigit = 0

@onready var secondsLabelFirstDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Seconds1
@onready var secondsLabelSecondDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Seconds2
@onready var minutesLabelFirstDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Minutes1
@onready var minutesLabelSecondsDigit = $GameTime/MarginContainer/VBoxContainer/HBoxContainer/Minutes2


func _ready():
	seconds = PlayerVariables.player_timer_seconds


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds += delta
	PlayerVariables.player_timer_seconds = seconds
	# Operations to calculate what digit corresponds to each digit text
	secondsFirstDigit = str(int(seconds) % 10)
	secondsSecondDigit = str((int(seconds) / 10) % 6)
	minutesFirstDigit = str((int(seconds) / 60) % 10)
	minutesSecondsDigit = str(int(seconds) / 600 % 6)
	
	secondsLabelFirstDigit.text = secondsFirstDigit
	secondsLabelSecondDigit.text = secondsSecondDigit
	minutesLabelFirstDigit.text = minutesFirstDigit
	minutesLabelSecondsDigit.text = minutesSecondsDigit
