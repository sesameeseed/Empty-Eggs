extends TileMap

func _on_change_1_body_entered(body):
	var top = $top2.position.y
	var bottom = $bottom2.position.y
	body.get_node("Camera2D").adjust_limits(top, bottom)


func _on_change_2_body_entered(body):
	var top = $top3.position.y
	var bottom = $bottom3.position.y
	body.get_node("Camera2D").adjust_limits(top, bottom)
