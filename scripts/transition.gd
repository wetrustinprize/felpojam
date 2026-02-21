extends CanvasLayer

@export var shader_material: ShaderMaterial

func transition_in(center_at: Node2D):
	set_center(center_at)

	var tween = get_tree().create_tween()

	tween.tween_method(set_shader_value, 0.0, 1.5, 0.3)
	await tween.finished

func transition_out(center_at: Node2D):
	set_center(center_at)

	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 1.5, 0.0, 0.3)

	await tween.finished

func set_center(node: Node2D):
	var camera = get_viewport().get_camera_2d()
	var relative = node.global_position - camera.get_target_position()

	relative.x = relative.x / (camera.get_viewport_rect().size.x / 2)
	relative.y = relative.y / (camera.get_viewport_rect().size.y / 2)

	relative.x = (relative.x + 1.0) * 0.5
	relative.y = (relative.y + 1.0) * 0.5

	print(relative)

	shader_material.set_shader_parameter("position", relative)


func set_shader_value(value: float):
	shader_material.set_shader_parameter("progress", value)
