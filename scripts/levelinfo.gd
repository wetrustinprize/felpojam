@tool
@icon("res://addons/plenticons/icons/16x/objects/key-white.png")

extends Node2D
class_name LevelInfo

@export var preview_camera_shape: bool = false:
	set(new_value):
		queue_redraw()
		preview_camera_shape = new_value

@export var camera_shape: RectangleShape2D:
	set(new_value):
		if camera_shape == new_value:
			return

		if camera_shape != null and camera_shape.changed.is_connected(queue_redraw):
			camera_shape.changed.disconnect(queue_redraw)

		camera_shape = new_value
		if camera_shape != null and not camera_shape.changed.is_connected(queue_redraw):
			camera_shape.changed.connect(queue_redraw)

		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	var shape_limits = camera_shape.size / 2
	var global_pos = global_position

	var camera = get_viewport().get_camera_2d()

	camera.limit_bottom = global_pos.y + shape_limits.y
	camera.limit_top = global_pos.y - shape_limits.y

	camera.limit_left = global_pos.x - shape_limits.x
	camera.limit_right = global_pos.x + shape_limits.x

func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	if camera_shape != null and preview_camera_shape:
		camera_shape.draw(get_canvas_item(), Color.DARK_BLUE)
