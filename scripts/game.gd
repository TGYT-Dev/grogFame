extends Node

@onready var levelContainer: Node = $LevelContainer
@onready var flashOverlay: ColorRect = $FlashOverlay

var stageScenes = {
	GameState.fState.egg: preload("res://scenes/levels/egg.tscn"),
	GameState.fState.tadpole: preload("res://scenes/levels/tadpole.tscn"),
	GameState.fState.froglet: preload("res://scenes/levels/froglet.tscn"),
	GameState.fState.frog: preload("res://scenes/levels/frog.tscn"),
}

func _ready() -> void:
	loadCurrentStage()

func loadCurrentStage() -> void:
	for child in levelContainer.get_children():
		child.queue_free()
	var scene = stageScenes[GameState.currentStage]
	levelContainer.add_child(scene.instantiate())

func onStageComplete() -> void:
	await playTransformFlash()
	GameState.advanceStage()
	loadCurrentStage()

func playTransformFlash() -> void:
	flashOverlay.modulate.a = 0.0
	flashOverlay.visible = true
	var tween = create_tween()
	tween.tween_property(flashOverlay, "modulate:a", 1.0, 0.15)
	tween.tween_property(flashOverlay, "modulate:a", 0.0, 0.3)
	await tween.finished
	flashOverlay.visible = false
	
