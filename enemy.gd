extends CharacterBody2D

const SPEED = 400.0
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
	shoottimer = $ShootTimer
	direction = 1
	velocity.x = SPEED

func _physics_process(delta):
	# gravity
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	# move around 
	move_and_slide()
	
	#conditions to shoot
	if player_detected and shoottimer.is_stopped():
		$AnimatedSprite2D.play("shoot")
		shoottimer.start()
		
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
func _on_detect_player_body_entered(body):
	if body.get_collision_layer() == 1:
		player = body
		previous_movement = velocity
		last_player_position = body.global_position
		velocity = Vector2(0,0)
		player_detected = true

# to move once player not in the body
func _on_detect_player_body_exited(body):
	if body.get_collision_layer() == 1:
		velocity = previous_movement
	player_detected = false
	

#determine arrows velocity and instantiates it
func _on_shoot_timer_timeout():
	var x_distance = player.global_position.x - global_position.x
	if x_distance <= 0:
		projectile_x_v = -projectile_x_s 
		t = (player.global_position.x - global_position.x) / projectile_x_v
	else:
		projectile_x_v = projectile_x_s 
		t = (player.global_position.x - global_position.x) / projectile_x_v

	var projectile_y_v = (player.global_position.y - global_position.y - 0.5 * projectile_gravity * t * t) / t
	var enemy_projectile_instantiate = enemy_projectile.instantiate()
	enemy_projectile_instantiate.global_position = global_position
	enemy_projectile_instantiate.velocity = Vector2(projectile_x_v,projectile_y_v)
	get_parent().add_child(enemy_projectile_instantiate)
	$AnimatedSprite2D.stop()
	pass # Replace with function body.
