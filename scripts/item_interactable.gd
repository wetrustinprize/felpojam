@tool
@icon("res://addons/plenticons/icons/16x/objects/door-open-white.png")

extends Interactable
class_name ItemInteractable

@export var item: Item
@export var depends_on_mission: String

func _ready() -> void:
	super._ready()

	if Inventory.has_item(item) or Inventory.had_item(item):
		queue_free()
		return

	if not depends_on_mission.is_empty():
		var depends = Missions.get(depends_on_mission)
		interactable = depends

	if Engine.is_editor_hint():
		return

	interact_verb = "pegar"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()

	if item == null:
		warnings.append("There is no item to be picked up")
	return warnings

func interact(_who: Interactor):
	Inventory.add_item(item)
	get_parent().queue_free()
