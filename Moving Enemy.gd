extends CharacterBody2D

const SPEED = 300.0
const DAMAGE = 20.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var previous_movement
var player_detected = false
var enemy_projectile = preload("res://enemy_projectile.tscn")
var last_player_position
var projectile_direction
var player
var shoottimer
var projectile_x_s = 200
var projectile_x_v
var t
var projectile_gravity = 10

var everytest = 1
var acc = 0


func _ready():
	direction = 1
	velocity.x = SPEED

func _physics_process(delta):
	# gravity
	if is_on_floor():
		velocity.y = 0
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.stop()
		velocity.y += gravity * delta
	
	# move around 
	move_and_slide()

	#detects collision
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#detect if body collided is a wall and then cahnegs direction
		if collision.get_normal().x == 1 or collision.get_normal().x == -1 :
			direction *= -1
			velocity.x = SPEED * direction

		
	# flip sprite
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true

# deal damage to player
func _on_area_2d_body_entered(body):
	if body.get_collision_layer() == 1:
		body.take_damage(DAMAGE)
# to stop when detects player

	


