@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var stickman_entity: DialogEntity = preload("res://entities/stickman.tres")

@export var stickman_animation_player: AnimationPlayer

func _ready() -> void:
	super._ready()

	interact_verb = "conversar"

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.first_stickman_talk:
		Missions.first_stickman_talk = true

		await Dialog.show_dialog(stickman_entity, "Bom dia, em que posso ajudar?")
		await Dialog.show_dialog(stickman_entity, "Portal? Universo? Ha? Atrás de mim? Não não é só o nosso almoxarifado mesmo.")

	if Missions.first_chefe_talk and not Missions.stickman_has_tp:
		if not Missions.stickman_requested_tp:
			Missions.stickman_requested_tp = true
			await Dialog.show_dialog(stickman_entity, "Você precisa de um papel higiênico?")
			await Dialog.show_dialog(stickman_entity, "Ah claro, aonde está o formulário carimbado solicitando o papel higiênico?")

		if not Missions.stickman_has_forms:
			await Dialog.show_dialog(stickman_entity, "... Você ta sem o formulário?")
			await Dialog.show_dialog(stickman_entity, "Sem problemas, você consegue pegar no segundo escritório com o Valdo.")
		if not Missions.stickman_has_stamp:
			await Dialog.show_dialog(stickman_entity, "... Você não tem o carimbo ainda?")
			await Dialog.show_dialog(stickman_entity, "Sem problemas, você consegue pegar no primeiro escritório com o Marselo.")

		if Missions.stickman_has_forms and Missions.stickman_has_stamp:
			await Dialog.show_dialog(stickman_entity, "Perfeito! Me entrega aqui que eu carimbo pra voce!")
			await Dialog.show_dialog(stickman_entity, "Um momento, já trago...")

			stickman_animation_player.play("bring_paper")

			await get_tree().create_timer(2).timeout

			await Dialog.show_dialog(stickman_entity, "Aqui está!")
			stickman_animation_player.play("RESET")
			Missions.stickman_has_tp = true
	else:
		await Dialog.show_dialog(stickman_entity, "Se precisar de alguma coisa só falar que eu consigo te ajudar!")

	Game.on_cutscene = false
