extends Node

enum fState {tadpole, froglet, frog}
var currentStage: fState = fState.tadpole
var foodEaten: int = 0
var foodRequired: int = 5

func eatFood() -> void:
	GameState.eatFood()
	sprite.play("tadpoleEat")

func advanceStage() -> void:
	match currentStage:
		fState.tadpole:
			currentStage = fState.froglet
		fState.froglet:
			currentStage = fState.frog
		fState.frog:
			pass
	foodEaten = 0
	
