extends Node2D

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.get_collision_layer() == 1:
		collected = true

func open_door(door):
	if collected:
		queue_free()
		door.queue_free()
