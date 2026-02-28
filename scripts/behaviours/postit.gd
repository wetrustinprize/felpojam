@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var postit_entity: DialogEntity = preload("res://entities/postit.tres")

func _ready() -> void:
	super._ready()

	interact_verb = "ler"

func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	await Dialog.show_dialog(postit_entity, "\"Fui ao banheiro!\" - chefe")

	Game.on_cutscene = false
