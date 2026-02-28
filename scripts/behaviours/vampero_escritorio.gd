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

	if not Inventory.had_item(papelada_item):
		await Dialog.show_dialog(vampire_entity, "Hmmmm... finalmente no meu lar...")
		await Dialog.show_dialog(vampire_entity, "Se bem que ser um vampiro e estar trabalhando em um cartório...")
		await Dialog.show_dialog(vampire_entity, "Meu pai, Odlav, disse que eu seria um fracasso...")
		await Dialog.show_dialog(vampire_entity, "Bom, vá para o almoxarifado e pegue uma recompensa pra você")

		Inventory.add_item(papelada_item)
	else:
		await Dialog.show_dialog(vampire_entity, "Eu acho que meu pai estava correto...")

	Game.on_cutscene = false
