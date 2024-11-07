extends Control

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureProgressBar.value = player.health
	$Label2.text = 'x' + str(player.egg_count)
