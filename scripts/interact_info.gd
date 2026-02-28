extends Node2D

@export var label: Label

var current: Interactable = null

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if visible and not Game.player_can_control:
		_hide()
	elif not visible and Game.player_can_control and current != null:
		_show()

func _on_interactor_can_interact_with(interactable: Interactable) -> void:
	current = interactable
	_show()

func _on_interactor_cannot_interact_anymore() -> void:
	current = null
	_hide()

func _hide() -> void:
	visible = false

func _show() -> void:
	visible = true
	label.text = "Para %s!" % current.interact_verb
