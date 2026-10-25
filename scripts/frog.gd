extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tongueLine: Line2D = $Tongue/Line2D
@onready var tongueTip: Area2D = $Tongue/TongueTip
@onready var tipCollision: CollisionShape2D = $Tongue/TongueTip/CollisionShape2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TONGUE_SPEED = 2000.0

var isExtending := false
var isRetracting := false
var currentLength := 0.0
var targetDirection := Vector2.RIGHT
var isEating := false

func _ready() -> void:
	tongueLine.points = [Vector2.ZERO, Vector2.ZERO]
	tipCollision.disabled = true

func _physics_process(delta: float) -> void:
	var moveDir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	match GameState.currentStage:
		GameState.fState.tadpole:
			velocity = moveDir * SPEED
		GameState.fState.froglet, GameState.fState.frog:
			if not is_on_floor():
				velocity += get_gravity() * delta
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY
			velocity.x = moveDir.x * SPEED

	if moveDir.x > 0:
		sprite.flip_h = false
	elif moveDir.x < 0:
		sprite.flip_h = true

	handleAnimations(moveDir)
	updateTongue(delta)
	move_and_slide()


func handleAnimations(moveDir: Vector2) -> void:
	if isEating:
		return
	match GameState.currentStage:
		GameState.fState.tadpole:
			sprite.play("tadpoleSwimClosed")
		GameState.fState.froglet:
			sprite.play("frogletWalk" if moveDir.x != 0 else "frogletIdle")
		GameState.fState.frog:
			sprite.play("frogWalk" if moveDir.x != 0 else "frogIdle")


func eatAnimation() -> void:
	isEating = true
	match GameState.currentStage:
		GameState.fState.tadpole:
			sprite.play("tadpoleSwimOpen")
			await sprite.animation_finished
			sprite.play("tadpoleSwimClosed")
		GameState.fState.froglet:
			sprite.play("frogletEat")
		GameState.fState.frog:
			sprite.play("frogEat")
	isEating = false


func getMaxTongueLength() -> float:
	match GameState.currentStage:
		GameState.fState.froglet:
			return 150.0
		GameState.fState.frog:
			return 300.0
		_:
			return 0.0

func _unhandled_input(event: InputEvent) -> void:
	if GameState.currentStage == GameState.fState.egg or GameState.currentStage == GameState.fState.tadpole:
		return
	if event is InputEventMouseButton and event.pressed and not isExtending and not isRetracting:
		fireTongue()

func fireTongue() -> void:
	targetDirection = (get_global_mouse_position() - global_position).normalized()
	isExtending = true
	tipCollision.disabled = false

func updateTongue(delta: float) -> void:
	var maxLength := getMaxTongueLength()

	if isExtending:
		currentLength += TONGUE_SPEED * delta
		if currentLength >= maxLength:
			currentLength = maxLength
			isExtending = false
			isRetracting = true
	elif isRetracting:
		currentLength -= TONGUE_SPEED * delta
		if currentLength <= 0:
			currentLength = 0
			isRetracting = false
			tipCollision.disabled = true

	var tipPosition: Vector2 = targetDirection * currentLength
	tongueLine.points = [Vector2.ZERO, tipPosition]
	tongueTip.position = tipPosition

func _on_tongue_tip_area_entered(area: Area2D) -> void:
	var validGroup := ""
	match GameState.currentStage:
		GameState.fState.froglet:
			validGroup = "cricket"
		GameState.fState.frog:
			validGroup = "fly"

	if validGroup != "" and area.is_in_group(validGroup):
		area.queue_free()
		GameState.eatFood()
		eatAnimation()
		isExtending = false
		isRetracting = true
		
