@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var veterinario_animation: AnimationPlayer
@export var veterinario_node: Node2D
@export var door_sfx: AudioStreamPlayer
@export var fight_sfx: AudioStreamPlayer

@onready var veterinario_entity = preload("res://entities/veterinario.tres")
@onready var seringa_item = preload("res://items/vacina.tres")

var anim_state: STATE = STATE.NORMAL

enum STATE {
	NORMAL,
	INJECAO,
	PRANCHETA,
}

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if Missions.veterinario_at_escritorio or not Missions.veterinario_at_corredor:
		veterinario_node.queue_free()
		return

	veterinario_entity.started_talking.connect(func():
		var animation: String

		match anim_state:
			STATE.NORMAL:
				animation = "talking"
			STATE.INJECAO:
				animation = "talking_injecao"
			STATE.PRANCHETA:
				animation = "talking_prancheta"

		veterinario_animation.play(animation)
	);

	veterinario_entity.stopped_talking.connect(func():
		veterinario_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.first_veterinario_talk:
		Missions.first_veterinario_talk = true

		anim_state = STATE.PRANCHETA
		await Dialog.show_dialog(veterinario_entity, "Hm... Vejamos... ele está atrasado com a injeção contra pulgas...")

		anim_state = STATE.NORMAL
		await Dialog.show_dialog(veterinario_entity, "Ah nossa! Eu nem percebi você aí! Estou me preparando e guardando a porta para meu paciente não fugir.")
		await Dialog.show_dialog(veterinario_entity, "Se for falar com ele por favor não mencione nada sobre vacinas ou idas ao médico, Okay?")
		await Dialog.show_dialog(veterinario_entity, "O que? Como eu entrei aqui? Ah, hah... bom... A recepcionista me deixou entrar sem nenhum problema...")

	else:
		if Inventory.has_item(seringa_item):
			anim_state = STATE.NORMAL
			await Dialog.show_dialog(veterinario_entity, "Aha! Você achou!")

			Inventory.remove_item(seringa_item)

			anim_state = STATE.INJECAO
			await Dialog.show_dialog(veterinario_entity, "Agora sim posso terminar meu trabalho aqui! Obrigado!")

			door_sfx.play()
			get_parent().visible = false
			await door_sfx.finished
			fight_sfx.play()
			await fight_sfx.finished
			get_parent().queue_free()

			Missions.veterinario_at_escritorio = true
		else:
			if not Missions.veterinario_lost_injection:
				await Dialog.show_dialog(veterinario_entity, "Ele não parece muito animado não né...")
				await Dialog.show_dialog(veterinario_entity, "Bom, vamos lá, à vacina.")
				await Dialog.show_dialog(veterinario_entity, "[spd 0.05] [spd 1]... [spd 0.05] [spd 1]... [spd 0.05] [spd 1]... [spd 0.05] [spd 1] cadê a minha vacina?")

				anim_state = STATE.PRANCHETA
				await Dialog.show_dialog(veterinario_entity, "Ah droga! Eu perdi a injeção dele! Mas eu estava com ela hoje mais cedo!")
				anim_state = STATE.NORMAL
				await Dialog.show_dialog(veterinario_entity, "Estava até brincando com ela na recepção, quase me espetei com ela!")
				await Dialog.show_dialog(veterinario_entity, "Ela ainda deve estar por aqui! Caso encontre ela traga para mim! Eu não posso sair daqui, preciso garantir que ele não vai fugir!")
				Missions.veterinario_lost_injection = true
			
			else:
				await Dialog.show_dialog(veterinario_entity, "Conseguiu procurar a minha injeção? Eu não posso sair daqui senão se ele me ver ele vai fugir!")

			anim_state = STATE.NORMAL

	Game.on_cutscene = false
