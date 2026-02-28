@tool
@icon("res://addons/plenticons/icons/16x/objects/door-open-white.png")

extends Interactable
class_name ItemInteractable

@export var item: Item
@export var depends_on_mission: Array[String]
@export var depends_on_mission_to_show: Array[String]

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	if Inventory.has_item(item) or Inventory.had_item(item):
		get_parent().queue_free()
		return

	if not depends_on_mission_to_show.is_empty():
		var depends = true

		for depend in depends_on_mission_to_show:
			var ok = Missions.get(depend)

			if not ok:
				depends = false
				break

		if not depends:
			get_parent().queue_free()
			return

	if not depends_on_mission.is_empty():
		var depends = true

		for depend in depends_on_mission:
			var ok = Missions.get(depend)

			if not ok:
				depends = false
				break

		interactable = depends

	interact_verb = "pegar"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()

	if item == null:
		warnings.append("There is no item to be picked up")
	return warnings

func interact(_who: Interactor):
	Inventory.add_item(item)
	get_parent().queue_free()
