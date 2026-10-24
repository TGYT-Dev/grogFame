extends Node

enum fState {egg, tadpole, froglet, frog}
var currentStage: fState = fState.egg
var foodEaten: int = 0
var foodRequired: int = 5

func eatFood() -> void:
	foodEaten += 1

func advanceStage() -> void:
	match currentStage:
		fState.egg:
			currentStage = fState.tadpole
		fState.tadpole:
			currentStage = fState.froglet
		fState.froglet:
			currentStage = fState.frog
		fState.frog:
			pass
	foodEaten = 0
	
