extends RoomBase


@onready var player = get_parent().get_node("Player") # Player variable

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = $PlayerSpawnPoint.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

