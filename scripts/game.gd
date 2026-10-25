extends Node

@onready var levelContainer: Node = $LevelContainer
@onready var flashOverlay: ColorRect = $CanvasLayer/FlashOverlay

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
	var instance = scene.instantiate()
	levelContainer.add_child(instance)

	var land: StaticBody2D = instance.get_node_or_null("Land")
	if land:
		land.updateWaterBarrier()

var isTransitioning := false

func onStageComplete() -> void:
	if isTransitioning:
		return
	isTransitioning = true

	await fadeToWhite()
	GameState.advanceStage()
	loadCurrentStage()
	await get_tree().create_timer(0.3).timeout
	await fadeFromWhite()

	isTransitioning = false

func fadeToWhite() -> void:
	flashOverlay.modulate.a = 0.0
	flashOverlay.visible = true
	var tween = create_tween()
	tween.tween_property(flashOverlay, "modulate:a", 1.0, 0.4)
	await tween.finished

func fadeFromWhite() -> void:
	var tween = create_tween()
	tween.tween_property(flashOverlay, "modulate:a", 0.0, 0.5)
	await tween.finished
	flashOverlay.visible = false
	
