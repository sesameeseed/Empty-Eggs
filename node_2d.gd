extends Area2D

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open_door(door):
	collected = true
	queue_free()
	door.queue_free()


func _on_body_entered(body):
	if body.get_collision_layer() == 1:
		collected = true
