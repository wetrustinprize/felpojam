@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var compuiter_entity: DialogEntity = preload("res://entities/compuiter.tres")

func _ready() -> void:
	super._ready()

	interact_verb = "fuçar"

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	await Dialog.show_dialog(compuiter_entity, "É possível ler o histórico de quem usou esse computador, tem várias pesquisas estranhas")
	await Dialog.show_dialog(compuiter_entity, "\"tinta de carimbo na gelatina faz mal?\"")
	await Dialog.show_dialog(compuiter_entity, "\"como fazer amigos grátis\"")
	await Dialog.show_dialog(compuiter_entity, "\"é uma péssima ideia colocar o carimbo importante de seu colega de trabalho em uma gelatina?\"")
	await Dialog.show_dialog(compuiter_entity, "\"como medir 250ml de água sem um medidor\"")
	await Dialog.show_dialog(compuiter_entity, "\"terapia para vampiros\"")
	await Dialog.show_dialog(compuiter_entity, "\"cachorros podem comer gelatina?\"")

	Game.on_cutscene = false
