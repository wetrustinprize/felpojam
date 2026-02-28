@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var chefe_entity: DialogEntity = preload("res://entities/chefe.tres")

func _ready() -> void:
	super._ready()

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
	else:
		await Dialog.show_dialog(chefe_entity, "oh.... traga-me papel higienico e eu consigo te ajudar....")
		await Dialog.show_dialog(chefe_entity, "é provavel que tenha no almoxarifado.....")

	Game.on_cutscene = false
