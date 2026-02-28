@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var vampero_animation: AnimationPlayer
@export var vampero_node: Node2D
@export var vampero_end_position: Node2D
@export var door_sfx: AudioStreamPlayer

@onready var vampire_entity = preload("res://entities/vampire.tres")

func _ready() -> void:
	super._ready()

	if Missions.vampero_at_escritorio:
		vampero_node.queue_free()
		return

	vampire_entity.started_talking.connect(func():
		vampero_animation.play("talking")
	);

	vampire_entity.stopped_talking.connect(func():
		vampero_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.first_vampero_talk:
		Missions.first_vampero_talk = true
		await Dialog.show_dialog(vampire_entity, "[snd 0]Heh... olá pequenino...")
		await Dialog.show_dialog(vampire_entity, "[snd 0]Você poderia ajudar um senhor [i]normal[/i] igual a mim?")
		await Dialog.show_dialog(vampire_entity, "[snd 0]Eu só preciso que você... me convide para entrar na minha sala...")

		interact_verb = "convidar"
	else:
		await Dialog.show_dialog(vampire_entity, "[snd 0]Heh... obrigado pequenino...")

		vampero_animation.play("walking")

		var tween = get_tree().create_tween()
		tween.tween_property(vampero_node, "global_position", vampero_end_position.global_position, 4.0)

		await tween.finished
		door_sfx.play()
		vampero_node.visible = false

		Missions.vampero_at_escritorio = true

		await door_sfx.finished
		vampero_node.queue_free()

	Game.on_cutscene = false
