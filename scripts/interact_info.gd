extends Node2D

func _ready() -> void:
	visible = false

func _on_interactor_can_interact_with(_interactable: Interactable) -> void:
	visible = true

func _on_interactor_cannot_interact_anymore() -> void:
	visible = false
