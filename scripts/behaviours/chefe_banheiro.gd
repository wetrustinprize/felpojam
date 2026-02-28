@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var chefe_de_pe: Node2D
@export var door_sfx: AudioStreamPlayer
@export var flush_sfx: AudioStreamPlayer
@export var belly_sfx: AudioStreamPlayer
@export var chefe_animation_player: AnimationPlayer
@export var chefe_no_banheiro: Node2D
@export var final_cutscene: PackedScene
@export var credits_cutscene: PackedScene

@onready var chefe_entity: DialogEntity = preload("res://entities/chefe.tres")
@onready var toilet_paper: Item = preload("res://items/papel_higienico.tres")

func _ready() -> void:
	super._ready()

	chefe_de_pe.visible = false

	if Engine.is_editor_hint():
		return

	chefe_entity.started_talking.connect(func():
		chefe_animation_player.play("talking")
	);

	chefe_entity.stopped_talking.connect(func():
		chefe_animation_player.stop()
	);

	interact_verb = "conversar"

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.first_chefe_talk:
		Missions.first_chefe_talk = true

		await Dialog.show_dialog(chefe_entity, "oh... oh..... que dor...")
		await Dialog.show_dialog(chefe_entity, "oh..... pera, tem alguem ai?")
		await Dialog.show_dialog(chefe_entity, "você precisa carimbar uma papelada? ah eu posso ajudar com isso, mas oh.....")
		await Dialog.show_dialog(chefe_entity, "acabou o papel higienico, e eu preciso ao menos me limpar pra ir ai te ajudar....")
		await Dialog.show_dialog(chefe_entity, "é pra ter no final do corredor, dentro do almoxarifado, peça pro moço do almoxarifado")
	elif Inventory.has_item(toilet_paper):
		await Dialog.show_dialog(chefe_entity, "perfeito! perfeito! passa por aqui debaixo")

		Inventory.remove_item(toilet_paper)

		flush_sfx.play()
		belly_sfx.stop()

		await get_tree().create_timer(6.5).timeout

		door_sfx.play()
		chefe_no_banheiro.visible = false
		chefe_de_pe.visible = true

		await Dialog.show_dialog(chefe_entity, "bom, aonde estavamos?")
		await Transition.transition_out()

		var cutscene = final_cutscene.instantiate()
		get_tree().root.add_child(cutscene)

		await Transition.transition_in()
		cutscene.get_node("AnimationPlayer").play("show")

		await get_tree().create_timer(0.6).timeout
		await Dialog.show_dialog(chefe_entity, "ah sim! claro.")
		await Dialog.show_dialog(chefe_entity, "bom, vamos lá oficializar seu documento então!")

		cutscene.get_node("AnimationPlayer").play("show_paper")
		await get_tree().create_timer(2.2).timeout

		await Dialog.show_dialog(chefe_entity, "cá está! oficializado!")
		await Transition.transition_out(3)

		await get_tree().create_timer(1).timeout

		var credits = credits_cutscene.instantiate()
		get_tree().root.add_child(credits)
		return
	else:
		await Dialog.show_dialog(chefe_entity, "oh.... traga-me papel higienico e eu consigo te ajudar....")
		await Dialog.show_dialog(chefe_entity, "é provavel que tenha no almoxarifado.....")

	Game.on_cutscene = false
