extends Area2D

func _ready() -> void:
	add_to_group("algae")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GameState.eatFood()
		body.eatAnimation()
		queue_free()
		
