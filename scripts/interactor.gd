@tool
@icon("res://addons/plenticons/icons/16x/symbols/crosshair-blue.png")

extends Area2D
class_name Interactor

signal can_interact_with(interactable: Interactable)
signal cannot_interact_anymore

var current_selected: Interactable = null

func interact() -> void:
	if current_selected == null:
		print("nothing to interact with!")
		return

	print("interacting with %s" % current_selected.name)
	await current_selected.interact(self)

func _ready() -> void:
	self.body_entered.connect(_entered)
	self.body_exited.connect(_exited)

func _entered(body: Node2D) -> void:
	if body.has_meta("interaction") and not body.is_queued_for_deletion():
		print("%s has a interaction module!" % body.name)

		current_selected = body.get_meta("interaction")
		can_interact_with.emit(current_selected)

func _exited(body: Node2D) -> void:
	if body.has_meta("interaction"):
		var interaction = body.get_meta("interaction")

		if interaction == current_selected:
			current_selected = null
			cannot_interact_anymore.emit()
			print("%s has left the area, and is the select one! resetting..." % body.name)
		else:
			print("%s has left the area, but its not the current selected! so ignoring" % body.name)
