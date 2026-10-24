extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	if GameState.currentStage == GameState.fState.tadpole:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

	move_and_slide()
