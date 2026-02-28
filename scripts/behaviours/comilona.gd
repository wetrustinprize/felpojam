@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var comilona_animation: AnimationPlayer
@onready var comilona_entity = preload("res://entities/comilona.tres")
@onready var gelatina_item = preload("res://items/gelatina.tres")
@onready var carimbo_inventario = preload("res://items/carimbo_inventario.tres")

var animation_state: STATE = STATE.IRRITADA

enum STATE {
	IRRITADA,
	ALEGRE
}

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	comilona_entity.started_talking.connect(func():
		var animation: String

		match animation_state:
			STATE.IRRITADA:
				animation = "talking_angry"
			STATE.ALEGRE:
				animation = "talking_happy"

		comilona_animation.play(animation)
	);

	comilona_entity.stopped_talking.connect(func():
		comilona_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.first_comilona_talk:
		Missions.first_comilona_talk = true

		await Dialog.show_dialog(comilona_entity, "qq tu quer? n vem falar comigo q eu to morrendo de fome")
		await Dialog.show_dialog(comilona_entity, "eu MATARIA por um doce agora")
		await Dialog.show_dialog(comilona_entity, "olha, pequenino, ja q tu ta aqui fazendo nada")
		await Dialog.show_dialog(comilona_entity, "eu DUVIDO vc achar um doce pra eu comer, DUVIDO.")

		if Inventory.has_item(gelatina_item):
			await Dialog.show_dialog(comilona_entity, "o que? você já tem um doce ai??")
	if Inventory.has_item(gelatina_item):
		animation_state = STATE.ALEGRE
		await Dialog.show_dialog(comilona_entity, "NEM FUDENDO!!!")

		Inventory.remove_item(gelatina_item)
		comilona_animation.play("eat")

		await comilona_animation.animation_finished

		await Dialog.show_dialog(comilona_entity, "vc fez meu dia, na moral")
		await Dialog.show_dialog(comilona_entity, "o que? você precisava daquele carimbo?")
		await Dialog.show_dialog(comilona_entity, "pfft, aquele lá era inutil mesmo")

		await Dialog.show_dialog(comilona_entity, "mas pega esse aqui q eu peguei \"emprestado\" por um tempo do almoxarifado")
		Inventory.add_item(carimbo_inventario)

		await Dialog.show_dialog(comilona_entity, "n vai contar pra ele em! vai saber o que ele é capaz de fazer")

	elif Inventory.had_item(gelatina_item):
		animation_state = STATE.ALEGRE
		await Dialog.show_dialog(comilona_entity, "valeu maninho! vc n sabe como deixou meu dia melhor")

		animation_state = STATE.IRRITADA
		await Dialog.show_dialog(comilona_entity, "agora me deixa em paz pelo amor de deus eu tenho que entrega isso antes das 23:99")
	else:
		await Dialog.show_dialog(comilona_entity, "cade meu doce cara? to cagada de fome")

	comilona_animation.play("idle")
	Game.on_cutscene = false
