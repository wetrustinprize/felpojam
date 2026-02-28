@tool
@icon("res://addons/plenticons/icons/16x/symbols/crosshair-blue.png")

extends Area2D
class_name Interactor

signal can_interact_with(interactable: Interactable)
signal cannot_interact_anymore

var current_selected: Interactable = null

func interact() -> void:
	if current_selected == null:
		return

	print("interacting with %s" % current_selected.name)

	@warning_ignore("redundant_await")
	await current_selected.interact(self)

	if current_selected == null or not current_selected.interactable or current_selected.is_queued_for_deletion():
		_reset_current()

func recheck() -> void:
	var overlaping = get_overlapping_bodies()

	for overlap in overlaping:
		_entered(overlap)

func _ready() -> void:
	self.body_entered.connect(_entered)
	self.body_exited.connect(_exited)

func _entered(body: Node2D) -> void:
	if body.has_meta("interaction") and not body.is_queued_for_deletion():
		var interactor: Interactable = body.get_meta("interaction")

		if not interactor.interactable:
			return

		current_selected = interactor
		can_interact_with.emit(current_selected)

func _exited(body: Node2D) -> void:
	if body.has_meta("interaction"):
		var interaction = body.get_meta("interaction")

		if interaction == current_selected:
			_reset_current()

func _reset_current():
	current_selected = null
	cannot_interact_anymore.emit()
