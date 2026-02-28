extends Node

var disabled = false

func _process(_delta: float) -> void:
	if disabled:
		return

	var player: Node2D = get_tree().get_nodes_in_group("Player")[0]
	var parent: Node2D = get_parent()

	parent.scale.x = 1 if player.global_position.x < parent.global_position.x else -1
