extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		startGame()
	elif event.is_action_pressed("ui_accept"):
		startGame()

func startGame() -> void:
	get_tree().get_root().get_node("Game").onStageComplete()
	
