extends CanvasLayer

@export var portrait: TextureRect
@export var entity_name: Label
@export var dialogue: DialogueLabel
@export var animation_tree: AnimationNodeStateMachine

var current_who: DialogEntity = null
var showing_dialog := false

signal message_started
signal message_finished

func _ready() -> void:
	dialogue.message_finished.connect(func():
		if not current_who == null:
			current_who.stopped_talking.emit()
	)

func _input(event: InputEvent) -> void:
	if not visible or not showing_dialog:
		return

	if event.is_action_pressed("interact"):
		skip_dialog()

func skip_dialog() -> void:
	if dialogue.finished_showing():
		showing_dialog = false
		message_finished.emit()
	else:
		dialogue.skip_message()

func show_dialog(who: DialogEntity, text: String) -> void:
	portrait.texture = who.portrait
	entity_name.text = who.name
	dialogue.sound_files = who.sounds
	dialogue.messages = ["[spd 1.0]" + text]
	showing_dialog = true
	dialogue.start_dialogue()
	who.started_talking.emit()
	current_who = who
	message_started.emit()
	await message_finished
