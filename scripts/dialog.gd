extends CanvasLayer

@export var portrait: TextureRect
@export var dialogue: DialogueLabel

signal message_finished

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("interact"):
		skip_dialog()

	if event.is_action_pressed("toggle_quest"):
		fast_forward_dialog()

func skip_dialog() -> void:
	if dialogue.finished_showing():
		visible = false
		message_finished.emit()
	else:
		print("message has not finished showing yet!")

func fast_forward_dialog() -> void:
	dialogue.skip_message()

func show_dialog(who: DialogEntity, text: String) -> void:
	portrait.texture = who.portrait

	dialogue.sound_files = who.sounds
	dialogue.messages = [text]

	visible = true

	dialogue.start_dialogue()
	await message_finished
