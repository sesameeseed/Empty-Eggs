extends CharacterBody2D

const SPEED = 200.0
const DAMAGE = 20.0

var direction = 1


func _physics_process(delta):
	# move around
	velocity.x = direction * SPEED
	var collision = move_and_collide(velocity * delta)
	if collision:
		direction *= -1
		
	# flip sprite
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

# get attacked/deal damage to player
func _on_area_2d_body_entered(body):
	if not body.can_dash:
		queue_free()
	else:
		body.take_damage(DAMAGE)
