@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Node
class_name Interactable

signal on_interact(who: Interactor)

func interact(who: Interactor) -> void:
	on_interact.emit(who)

func _ready() -> void:
	var parent = get_parent()
	parent.set_meta("interaction", self)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	var parent = get_parent()

	if parent is not CollisionObject2D:
		warnings.append("Parent must be an CollisionObject2D")

	return warnings
