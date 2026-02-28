extends Area2D

@export var sfx: AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	if sfx.playing:
		return

	sfx.play()
