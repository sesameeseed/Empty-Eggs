extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 100
const DAMAGE_INTERVAL = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var timer
var can_take_damage = true
var sprite
var egg_count = 2
var can_dash = true
var can_move = true
var gravity_multiplier = 1
var up_count = 0


func _ready():
	health = MAX_HEALTH
	timer = $DamageTimer
	timer.wait_time = DAMAGE_INTERVAL
	sprite = $Sprite

func _physics_process(delta):
	# Add gravity
	velocity.y += gravity * delta * gravity_multiplier

	# dash attack
	if Input.is_action_just_pressed("dash_attack"):
		if egg_count > 0:
			can_move = false
			dash_attack()
			
	# Handle movement
	if Input.is_action_just_released("ui_up"):
		up_count += 1
	if is_on_floor():
		up_count = 0
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	elif up_count > 0 and egg_count > 1:
		if Input.is_action_just_pressed("ui_up"):
			up_count += 1
			velocity.y  = 0
			gravity *= 0.2
		elif up_count > 1 and Input.is_action_just_released("ui_up"):
			gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
			
	if can_dash:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
		elif Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
	velocity.x = lerpf(velocity.x, 0, 0.1)
	move_and_slide()
	
	# Flip sprite (true = left, false = right)
	if velocity.x < 0:
		sprite.flip_h = true
		$Camera2D.drag_horizontal_offset = -1
			
	elif velocity.x > 0:
		sprite.flip_h = false
		$Camera2D.drag_horizontal_offset = 1
	
	# End game if jumped off map
	if position.y >= 1000:
		queue_free()
		
# Take damage when passing through enemy
func take_damage(damage_en):
	if can_take_damage:
		can_take_damage = false
		$DamageTimer.start()
		health -= damage_en
		if health <= 0:
			get_tree().reload_current_scene()
		print('Player lost ' + str(damage_en) + ' health')

# dash attack
func dash_attack():
	if can_dash:
		can_dash = false
		$DashTimer.start()
		velocity.x = 12 * SPEED * (0.5 - int(sprite.flip_h))
		print(velocity.x)

func _on_damage_timer_timeout():
	can_take_damage = true

func _on_dash_timer_timeout():
	can_dash = true
	
# End game when player hits spikes
func _on_hitbox_body_entered(body):
	if body == $"../spikes":
		get_tree().reload_current_scene()
	if body == $"../egg":
		egg_count += 1
		print("game done")
