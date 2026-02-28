extends CanvasLayer

@export var shader_material: ShaderMaterial

const MAX_TRANSITION: float = 2.0

func _ready() -> void:
	reset_center()

func transition_in(time: float = 0.3):
	var tween = get_tree().create_tween()

	tween.tween_method(set_shader_value, 0.0, MAX_TRANSITION, time)

	await tween.finished
	Game.on_transition = false

func transition_out(time: float = 0.3):
	reset_center()

	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, MAX_TRANSITION, 0.0, time)

	Game.on_transition = true
	await tween.finished

func reset_center():
	var center = Vector2(0.5, 0.5)
	shader_material.set_shader_parameter("position", center)


func set_shader_value(value: float):
	shader_material.set_shader_parameter("progress", value)
