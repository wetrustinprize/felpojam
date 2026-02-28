extends CanvasLayer

var showing_menu: bool = false

@onready var open_sfx: AudioStreamPlayer = $OpenSFX

func _input(event: InputEvent) -> void:
	if Game.on_cutscene or Game.on_main_menu:
		return

	if event.is_action_pressed("menu"):
		showing_menu = !showing_menu
		Game.on_game_menu = showing_menu

		if showing_menu:
			open_sfx.play()

func _on_quit_pressed() -> void:
	get_tree().quit()
