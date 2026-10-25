extends Area2D

func _ready() -> void:
	add_to_group("algae")

func _on_body_entered(body: Node2D) -> void:
	print("something entered: ", body.name)
	print("penis pneis pensin penisn peinsn pensisndmpe", GameState.foodEaten )
	if body.is_in_group("player"):
		
		GameState.eatFood()
		body.eatAnimation()
		queue_free()
		
