@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var vampero_animation: AnimationPlayer
@export var vampero_node: Node2D
@export var vampero_to_escritorio: Node2D
@export var vampero_to_copa: Node2D
@export var door_sfx: AudioStreamPlayer
@export var look_at_player: LookAtPlayer

@onready var vampire_entity = preload("res://entities/vampire.tres")

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if Missions.vampero_at_escritorio or (Missions.vampero_at_copa and not Missions.vampero_wants_to_go_escritorio):
		vampero_node.queue_free()
		return

	vampire_entity.started_talking.connect(func():
		vampero_animation.play("talking")
	);

	vampire_entity.stopped_talking.connect(func():
		vampero_animation.stop()
	);

func _go_to(location: Node2D, right: bool = false):
	look_at_player.disabled = true

	var parent: Node2D = get_parent()
	parent.scale.x = -1 if right else 1

	vampero_animation.play("walking")

	var tween = get_tree().create_tween()
	tween.tween_property(vampero_node, "global_position", location.global_position, 4.0)

	vampero_node.get_node("CollisionPolygon2D").disabled = true;

	await tween.finished
	vampero_node.get_node("CollisionPolygon2D").disabled = false;
	door_sfx.play()
	vampero_node.visible = false

	Missions.vampero_at_copa = true

	await door_sfx.finished
	vampero_node.queue_free()

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.vampero_wants_to_go_escritorio:
		if not Missions.first_vampero_talk:
			Missions.first_vampero_talk = true
			await Dialog.show_dialog(vampire_entity, "Heh... olá pequenino...")
			await Dialog.show_dialog(vampire_entity, "Sabe... eu estou com muita... sede... você pode me ajudar?")
			await Dialog.show_dialog(vampire_entity, "Eu só preciso que você... me convide para entrar na copa...")
			await Dialog.show_dialog(vampire_entity, "É simples... é que eu não gosto de entrar nos lugares aonde eu... não sou convidado...")

			interact_verb = "convidar"
		else:
			await Dialog.show_dialog(vampire_entity, "Heh... obrigado pequenino...")
			await _go_to(vampero_to_copa, true)
	elif not Missions.vampero_asks_to_go_escritorio:
		Missions.vampero_asks_to_go_escritorio = true

		await Dialog.show_dialog(vampire_entity, "Isso é vergonhoso... mas...")
		await Dialog.show_dialog(vampire_entity, "Você consegue me convidar para entrar no meu próprio escritório?")

		interact_verb = "convidar"
	else:
		Missions.vampero_at_escritorio = true

		await Dialog.show_dialog(vampire_entity, "Obrigado novamente.")
		await _go_to(vampero_to_escritorio)

	Game.on_cutscene = false
