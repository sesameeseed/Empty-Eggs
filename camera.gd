extends Camera2D

func _ready():
	zoom = Vector2(1, 1)


func adjust_limits(top, bottom):
	limit_top = top
	limit_bottom = bottom


func adjust_left_right(left, right):
	limit_left = left
	limit_right = right


func _on_player_grounded_updated(is_grounded):
	pass # Replace with function body.
