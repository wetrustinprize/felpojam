extends CanvasLayer

@export var shader_material: ShaderMaterial

const MAX_TRANSITION: float = 2.0

func _ready() -> void:
	reset_center()

func transition_in():
	var tween = get_tree().create_tween()

	tween.tween_method(set_shader_value, 0.0, MAX_TRANSITION, 0.3)

	await tween.finished
	Game.on_transition = false

func transition_out():
	reset_center()

	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, MAX_TRANSITION, 0.0, 0.3)

	Game.on_transition = true
	await tween.finished

func reset_center():
	var center = Vector2(0.5, 0.5)
	shader_material.set_shader_parameter("position", center)


func set_shader_value(value: float):
	shader_material.set_shader_parameter("progress", value)
