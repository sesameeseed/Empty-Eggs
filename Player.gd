extends CharacterBody2D

signal grounded_updated(is_grounded)

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_HEALTH = 100
const DAMAGE_INTERVAL = 2
const FEATHER = preload("res://feather.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var timer
var can_take_damage = true
var sprite
var egg_count
var can_dash = true
var can_double_jump = true
var is_grounded
var level_egg_available = true
var health_bar
# in order of egg count: dash attack, double jump, glide, wring feather

func _ready():
	health = MAX_HEALTH
	timer = $DamageTimer
	timer.wait_time = DAMAGE_INTERVAL
	sprite = $Sprite
	egg_count = get_tree().get_root().get_child(0).egg_count
	health_bar = $CanvasLayer/Control/TextureProgressBar

func _physics_process(delta):
	# Add gravity
	velocity.y += gravity * delta

	# Egg 1: Dash attack
	if Input.is_action_just_pressed("dash_attack") and egg_count > 0 and can_dash:
		dash_attack()
		
	# Egg 4: Wring feather
	if Input.is_action_just_pressed("wring_feather") and egg_count > 3 and health > 1:
		wring_feather()
	
	# Handle vertical movement
	if not is_on_floor():
		sprite.frame = 1
		# Egg 2: Double jump
		if egg_count > 1:
			if Input.is_action_just_pressed("ui_up") and can_double_jump:
				$jump.play()
				can_double_jump = false
				velocity.y = JUMP_VELOCITY
			# Egg 3: Glide
			elif egg_count > 2 and not can_double_jump:
				if Input.is_action_just_pressed("ui_up"):
					velocity.y  = 100
					gravity = 0
	else:
		can_double_jump = true
		if Input.is_action_just_pressed("ui_up"):
			$jump.play()
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_up"):
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if (not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"))) and can_dash:
		sprite.stop()
	
	# Handle horizontal movement
	if can_dash:
		if Input.is_action_pressed("ui_left"):
			sprite.play("player_run")
			velocity.x = -SPEED
		elif Input.is_action_pressed("ui_right"):
			sprite.play("player_run")
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
	
	# Check if grounded (for camera)
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded ==  null || is_grounded != was_grounded:
		emit_signal("grounded_updated",is_grounded) #Signals if player is grounded
	
	# End game if jumped off map
	if position.y >= 1000:
		get_tree().reload_current_scene()
	
		
# Take damage when passing through enemy
func take_damage(damage_en):
	$hit.play()
	if can_take_damage:
		can_take_damage = false
		$DamageTimer.start()
		health -= damage_en
		if health <= 0:
			get_tree().reload_current_scene()
		print('Player lost ' + str(damage_en) + ' health')

# Dash attack function
func dash_attack():
	$punch.play()
	can_dash = false
	can_take_damage = false
	sprite.play("dash_attack")
	$DashTimer.start()
	velocity.x = 12 * SPEED * (0.5 - int(sprite.flip_h))

func wring_feather():
	health -= 1
	var feather = FEATHER.instantiate()
	feather.position = position
	get_parent().add_child(feather)

func _on_damage_timer_timeout():
	can_take_damage = true

func _on_dash_timer_timeout():
	can_dash = true
	can_take_damage = true
	sprite.stop()

func _on_hitbox_body_entered(body):
	if body.get_collision_layer() == 2 and not can_dash:
		body.queue_free()
