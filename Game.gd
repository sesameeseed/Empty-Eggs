extends Node

const LEVEL1 = preload("res://Level 1.tscn")
const LEVEL2 = preload("res://Level 2.tscn")
const LEVELS = [LEVEL1, LEVEL2]

var curr_level
var new_level
var level_ind
var egg_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	level_ind = 0
	curr_level = LEVEL2.instantiate()
	add_child(curr_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level():
	if level_ind != 1:
		level_ind += 1
		new_level = LEVELS[level_ind].instantiate()
		add_child(new_level)
		curr_level.queue_free()
		curr_level = new_level
