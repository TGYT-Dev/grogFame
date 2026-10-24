extends Node

var state = GameState.fState

func setAnimation(animation: String) -> void:
	match GameState.currentStage:
		GameState.fState.egg:
			pass
		GameState.fState.tadpole:
			sprite.play(animation)
		GameState.fState.froglet:
			sprite.play(animation)
		GameState.fState.frog:
			sprite.play(animation)
			
