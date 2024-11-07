extends CharacterBody2D

var move_on = false

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down") and move_on:
		get_tree().get_root().get_child(0).change_level()

func _on_area_2d_body_entered(body):
	if body == $"../Player":
		if body.level_egg_available:
			body.egg_count += 1
			get_tree().get_root().get_child(0).egg_count += 1
			move_on = true
			body.level_egg_available = false
			get_parent().get_child($"../AudioStreamPlayer".get_index()).stop()
			$win.play()
			$Label.visible = true
