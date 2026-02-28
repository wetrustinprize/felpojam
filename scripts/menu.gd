extends CanvasLayer

var showing_menu: bool = false

func _input(event: InputEvent) -> void:
	if Game.on_cutscene:
		return

	if event.is_action_pressed("menu"):
		showing_menu = !showing_menu
		Game.on_game_menu = showing_menu
