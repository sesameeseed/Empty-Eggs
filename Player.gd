extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_HEALTH = 100
const DAMAGE_INTERVAL = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var timer
var can_take_damage = true
var sprite


func _ready():
	health = MAX_HEALTH
	timer = $DamageTimer
	timer.wait_time = DAMAGE_INTERVAL
	sprite = $Sprite

func _physics_process(delta):
	# Add gravity
	velocity.y += gravity * delta

	# Handle movement
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = lerpf(velocity.x, 0, 0.1)
	move_and_slide()
	
	# Flip sprite
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	# End game if jumped off map
	if position.y >= 1000:
		queue_free()
		
# Take damage when passing through enemy
func take_damage(damage_en):
	if can_take_damage:
		can_take_damage = false
		timer.start()
		health -= damage_en
		if health <= 0:
			queue_free()
		print('Player lost ' + str(damage_en) + ' health')

func _on_damage_timer_timeout():
	can_take_damage = true

# End game when player hits spikes
func _on_hitbox_body_entered(body):
	if body == $"../spikes":
		queue_free()
