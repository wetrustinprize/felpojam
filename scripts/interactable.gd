@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")
@abstract

extends Node
class_name Interactable

@abstract func interact(who: Interactor) -> void

func _ready() -> void:
	var parent = get_parent()
	parent.set_meta("interaction", self)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	var parent = get_parent()

	if parent is not CollisionObject2D:
		warnings.append("Parent must be an CollisionObject2D")

	return warnings
