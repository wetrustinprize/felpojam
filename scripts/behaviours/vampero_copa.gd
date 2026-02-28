@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var vampero_animation: AnimationPlayer
@export var vampero_node: Node2D
@export var vampero_end_position: Node2D
@export var door_sfx: AudioStreamPlayer
@export var look_at_player: LookAtPlayer

@onready var vampire_entity = preload("res://entities/vampire.tres")
@onready var vampire_key = preload("res://items/chave_do_vampiro.tres")

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if not Missions.vampero_at_copa or Missions.vampero_wants_to_go_escritorio or Missions.vampero_at_escritorio:
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

	await tween.finished
	door_sfx.play()
	vampero_node.visible = false

	Missions.vampero_at_copa = true

	await door_sfx.finished
	vampero_node.queue_free()


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.vampero_talked_about_chave:
		Missions.vampero_talked_about_chave = true

		await Dialog.show_dialog(vampire_entity, "Ah! como eu adoro um suco de uva! me faz lembrar do... passado...")
		await Dialog.show_dialog(vampire_entity, "Bom, eu acho que já ta na hora de começar a trabalhar infelizmente...")
		await Dialog.show_dialog(vampire_entity, "uh... eita... eu acho que perdi minha chave em algum lugar... você consegue me ajudar a acha-la?")
	elif Inventory.has_item(vampire_key):
		Missions.vampero_wants_to_go_escritorio = true

		await Dialog.show_dialog(vampire_entity, "Uau! você é incrível! já fiqueio com medo de não conseguir terminar as demandas de hoje!")
		Inventory.remove_item(vampire_key)
		await Dialog.show_dialog(vampire_entity, "Bom, vou me indo, se quiser falar comigo estarei no meu escritório!")
		await _go_to(vampero_end_position)
	else:
		await Dialog.show_dialog(vampire_entity, "Eu to tentando procurar a minha chave por aqui também... mas não to a encontrando...")

	Game.on_cutscene = false
