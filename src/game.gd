extends Node2D


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.reset_position()
