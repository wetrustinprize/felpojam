extends Sprite2D

@onready var layer: CanvasLayer = $CanvasLayer
@onready var fade: Sprite2D = $CanvasLayer/Fade

func _ready() -> void:
	layer.visible = true

	if not Missions.initial_cutscene:
		Game.on_main_menu = true

		await get_tree().create_timer(1).timeout

		var tween = get_tree().create_tween()
		tween.tween_property(fade, "modulate", Color.TRANSPARENT, 2)
	else:
		Game.on_main_menu = false
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

		Game.on_main_menu = false
