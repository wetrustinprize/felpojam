@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var form_item = preload("res://items/papel_inventario.tres")
@onready var stamp_item = preload("res://items/carimbo_inventario.tres")
@onready var tp_item = preload("res://items/papel_higienico.tres")
@onready var gelatina_item = preload("res://items/gelatina.tres")

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

	if Missions.first_chefe_talk and not Inventory.has_item(tp_item):
		if not Missions.stickman_requested_tp:
			Missions.stickman_requested_tp = true
			await Dialog.show_dialog(stickman_entity, "Você precisa de um papel higiênico?")
			await Dialog.show_dialog(stickman_entity, "Ah claro, aonde está o formulário carimbado solicitando o papel higiênico?")

		if not Inventory.has_item(form_item):
			await Dialog.show_dialog(stickman_entity, "... Você ta sem o formulário?")
			await Dialog.show_dialog(stickman_entity, "Sem problemas, você consegue pegar no segundo escritório com o Valdo.")
		if not Inventory.has_item(stamp_item):
			if Inventory.has_item(gelatina_item):
				await Dialog.show_dialog(stickman_entity, "[spd 0.05] [spd 1]... [spd 0.05] [spd 1]... [spd 0.05] [spd 1]...")
				await Dialog.show_dialog(stickman_entity, "O que é suposto eu fazer com isso?")
			else:
				await Dialog.show_dialog(stickman_entity, "... Você não tem o carimbo ainda?")
				await Dialog.show_dialog(stickman_entity, "Sem problemas, você consegue pegar no primeiro escritório com o Marselo.")

		if Inventory.has_item(form_item) and Inventory.has_item(stamp_item):
			await Dialog.show_dialog(stickman_entity, "Perfeito! Me entrega aqui que eu carimbo pra voce!")
			await Dialog.show_dialog(stickman_entity, "Um momento, já trago...")

			stickman_animation_player.play("bring_paper")

			await get_tree().create_timer(2).timeout

			await Dialog.show_dialog(stickman_entity, "Aqui está!")
			Inventory.add_item(tp_item)
			Inventory.remove_item(form_item)
			Inventory.remove_item(stamp_item)
			stickman_animation_player.play("RESET")

	else:
		await Dialog.show_dialog(stickman_entity, "Se precisar de alguma coisa só falar que eu consigo te ajudar!")

	Game.on_cutscene = false
