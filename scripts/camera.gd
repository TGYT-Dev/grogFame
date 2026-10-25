extends Camera2D

const ZOOM_SPEED = 0.1
const MIN_ZOOM = 0.5
const MAX_ZOOM = 3.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom - Vector2(ZOOM_SPEED, ZOOM_SPEED)).clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2(ZOOM_SPEED, ZOOM_SPEED)).clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
