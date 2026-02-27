extends CanvasLayer

@export var shader_material: ShaderMaterial

const MAX_TRANSITION: float = 4.0

func transition_in(center_at: Node2D):
	set_center(center_at)

	var tween = get_tree().create_tween()

	tween.tween_method(set_shader_value, 0.0, MAX_TRANSITION, 0.3)

	await tween.finished
	Game.on_transition = false

func transition_out(center_at: Node2D):
	set_center(center_at)

	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, MAX_TRANSITION, 0.0, 0.3)

	Game.on_transition = true
	await tween.finished

func set_center(node: Node2D):
	var camera = get_viewport().get_camera_2d()
	var rect = camera.get_viewport_rect().size
	var relative = node.global_position - camera.get_screen_center_position()

	relative.x += rect.x / 3
	relative.y += rect.y / 3

	relative.x = relative.x / rect.x
	relative.y = relative.y / rect.y

	shader_material.set_shader_parameter("position", relative)


func set_shader_value(value: float):
	shader_material.set_shader_parameter("progress", value)
