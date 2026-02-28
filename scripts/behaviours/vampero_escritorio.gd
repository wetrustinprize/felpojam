@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var vampero_animation: AnimationPlayer

@onready var vampire_entity = preload("res://entities/vampire.tres")
@onready var papelada_item = preload("res://items/papel_inventario.tres")

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if not Missions.vampero_at_escritorio:
		get_parent().queue_free()
		return

	vampire_entity.started_talking.connect(func():
		vampero_animation.play("talking")
	);

	vampire_entity.stopped_talking.connect(func():
		vampero_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	if not Missions.vampero_has_talked_sad_things:
		Missions.vampero_has_talked_sad_things = true

		await Dialog.show_dialog(vampire_entity, "Hmmmm... finalmente no meu lar...")
		await Dialog.show_dialog(vampire_entity, "Se bem que ser um vampiro e estar trabalhando em um cartório...")
		await Dialog.show_dialog(vampire_entity, "Meu pai, Odlav, disse que eu seria um fracasso...")
		await Dialog.show_dialog(vampire_entity, "E eu acho que sou mesmo... eu sou imortal e estou aqui?")
		await Dialog.show_dialog(vampire_entity, "Pelo menos alguns dias pessoas boas que nem você aparecem de vez em quando...")
		await Dialog.show_dialog(vampire_entity, "Faz tempo que não converso com ninguem... todos me ignoram aqui...")
		await Dialog.show_dialog(vampire_entity, "Eu tento até fazer algumas brincadeiras ou contar piadas, mas ninguém entende meu senso de humor...")

		if Missions.stickman_requested_tp and not Inventory.had_item(papelada_item):
			await Dialog.show_dialog(vampire_entity, "........")

	else:
		await Dialog.show_dialog(vampire_entity, "Eu acho que meu pai estava correto...")

	if Missions.stickman_requested_tp and not Inventory.had_item(papelada_item):
		await Dialog.show_dialog(vampire_entity, "Ah, o Bob pediu pra você um formulário de controle de inventário?")
		await Dialog.show_dialog(vampire_entity, "Claro, eu tenho umas cópias aqui sobrando... como você me ajudou o dia todo, por que não lhe ajudaria também?")
		Inventory.add_item(papelada_item)

	Game.on_cutscene = false
