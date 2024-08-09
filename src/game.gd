extends Node2D


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Projectile:
		area.exit_scene()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.reset_position()
