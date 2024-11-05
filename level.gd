extends Node2D

const CAMERA = preload("res://camera.tscn")
const PLAYER = preload("res://Player.tscn")

var player
var camera

#func _ready():
#	var top = $Map/top1.position.y
#	var bottom = $Map/bottom1.position.y
#	$Player/Camera2D.adjust_limits(top, bottom)
#
#	var rect = $Map.get_used_rect()
#	var size = $Map.cell_quadrant_size
#	$Player/Camera2D.adjust_left_right(rect.position.x * size, rect.end.x * size)
	
func init_camera():
	camera = CAMERA.instantiate()
	player.add_child(camera)

func init_player():
	player = PLAYER.instantiate()
	self.add_child(player)
	init_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
