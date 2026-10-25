extends StaticBody2D

@onready var waterSurface: CollisionShape2D = $WaterSurface

func updateWaterBarrier() -> void:
	waterSurface.disabled = GameState.currentStage != GameState.fState.tadpole
	
