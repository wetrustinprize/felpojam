extends Sprite2D

@onready var layer: CanvasLayer = $CanvasLayer
@onready var fade: TextureRect = $CanvasLayer/Fade
@onready var felpojam: TextureRect = $CanvasLayer/Fade/FelpoJam

var can_skip_menu: bool = false

func _ready() -> void:
	visible = true
	layer.visible = true

	if not Missions.initial_cutscene:
		Game.on_main_menu = true

		await get_tree().create_timer(1).timeout

		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_SINE)

		tween.tween_property(fade, "modulate", Color.TRANSPARENT, 2)
		tween.tween_property(felpojam, "modulate", Color.TRANSPARENT, 0.5)

		var y_felpojam_position = felpojam.position.y
		tween.tween_property(felpojam, "position:y", y_felpojam_position + 20, 0.6)

		tween.finished.connect(func():
			layer.queue_free()
		)

		await get_tree().create_timer(0.6).timeout
		can_skip_menu = true
	else:
		Game.on_main_menu = false
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_skip_menu:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

		Game.on_main_menu = false
