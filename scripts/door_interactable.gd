@tool
@icon("res://addons/plenticons/icons/16x/objects/door-open-white.png")

extends Interactable
class_name DoorInteractable

@export var new_scene: PackedScene
@export var spawpoint_name: String

func interact(who: Interactor) -> void:
	await Transition.transition_out(who.get_parent())

	var scene = new_scene.instantiate()
	get_tree().root.add_child(scene)

	await Transition.transition_in(who.get_parent())

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()

	if new_scene == null:
		warnings.append("There is no scene to load when entering this door")
	return warnings
