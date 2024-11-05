extends CharacterBody2D
const damage = 10.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 10


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	for i in get_slide_collision_count():
		queue_free()
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.get_collision_layer() == 1:
		body.take_damage(damage)
		queue_free()
	pass # Replace with function body.


func _on_despawn_timeout():
	queue_free()
	pass # Replace with function body.
