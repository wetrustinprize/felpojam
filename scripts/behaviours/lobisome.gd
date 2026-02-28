@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var lobisome_animation: AnimationPlayer
@export var slime_sfx: AudioStreamPlayer

@onready var lobisome_entity: DialogEntity = preload("res://entities/lobisome.tres")

var pointin: bool = false

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if Missions.veterinario_at_escritorio:
		interactable = false
		lobisome_animation.play("sleep")

	lobisome_entity.started_talking.connect(func():
		lobisome_animation.play("talking" if not pointin else "talking_pointing")
	);

	lobisome_entity.stopped_talking.connect(func():
		lobisome_animation.stop()
	);

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if Missions.lobisome_asleep:
		pass
	elif Missions.first_lobisomen_talk:
		await Dialog.show_dialog(lobisome_entity, "Vá Embora Pequenino, Me Deixe Em Paz.")
	else:
		await Dialog.show_dialog(lobisome_entity, "O Que Você Quer? Não Está Vendo Que Eu Estou Ocupado?")

		if Missions.stickman_requested_tp:
			Missions.first_lobisomen_talk = true

			await Dialog.show_dialog(lobisome_entity, "Oi? Precisa Do Meu Carimbo? Bom Eu Adoraria Te Emprestar Ele Mas...")
			pointin = true

			slime_sfx.play()
			await Dialog.show_dialog(lobisome_entity, "Algum Engraçadinho Achou Que Seria Legal Botar Ele Dentro De Uma Gelatina.")
			await Dialog.show_dialog(lobisome_entity, "Agora Ele Ta Meio Que Inutilizável.")

			pointin = false
			await Dialog.show_dialog(lobisome_entity, "O Quê? Não, Você Não Pode Pegar Ele, Vai Fazer Uma Bagunça No Escritório.")
			await Dialog.show_dialog(lobisome_entity, "E Também, Isso Seria Desperdício De Comida... Eu Vou Levar A Gelatina Para Meu Filho Comer.")
			await Dialog.show_dialog(lobisome_entity, "Então, Amanhã de Manhã Cedo Passe Aqui Novamente Que Eu Te Empresto O Carimbo.")
			await Dialog.show_dialog(lobisome_entity, "Agora Me Deixa Em Paz.")

	Game.on_cutscene = false

	if not Missions.lobisome_asleep:
		lobisome_animation.play("idle")
