extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		queue_free()
	pass # Replace with function body.
