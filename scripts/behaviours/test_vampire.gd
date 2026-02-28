@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@onready var vampire_entity = preload("res://entities/vampire.tres")

func interact(_who: Interactor) -> void:
	await Dialog.show_dialog(vampire_entity, "oi vritu vc é louquinho")
	await Dialog.show_dialog(vampire_entity, "o que voce quer do mcdonalds")
