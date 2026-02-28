@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var lobisome_animation: AnimationPlayer

@onready var lobisome_entity: DialogEntity = preload("res://entities/lobisome.tres")
@onready var bapo_entity: DialogEntity = preload("res://entities/bapo.tres")

var pointin: bool = false

func _ready() -> void:
	super._ready()

	interact_verb = "conversar"

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
		await Dialog.show_dialog(lobisome_entity, "Vá Embora Pequenino. Você Nem Deveria Estar Aqui.")
	else:
		Missions.first_lobisomen_talk = true
		await Dialog.show_dialog(lobisome_entity, "O Que Você Quer?")
		await Dialog.show_dialog(bapo_entity, "Oi! Aquele carimbo ali na sua mesa, eu posso usa-lo?")

		pointin = true
		await Dialog.show_dialog(lobisome_entity, "Não. Como Você Pode Ver Ela Está Em Volta De Uma Gelatina.")
		pointin = false

		await Dialog.show_dialog(bapo_entity, "Ah, mas isso não é um problema, eu posso tirar a gelatina em volta dela!")
		await Dialog.show_dialog(lobisome_entity, "Não. Você Vai Sujar Nosso Escritório. Aliás Quem É Você?")
		await Dialog.show_dialog(bapo_entity, "Eu vim aqui oficializar um documento, mas a recepcionista não tinha o carimbo, então eu vi maqui pegar...")
		await Dialog.show_dialog(lobisome_entity, "Então Você Nem Deveria Estar Aqui. Vá Embora.")

	Game.on_cutscene = false

	if not Missions.lobisome_asleep:
		lobisome_animation.play("idle")
