extends CharacterBody2D

@export var flip_nodes: Array[Node2D]
@export var animation_player: AnimatedSprite2D
@export var walk_sfx: AudioStreamPlayer

const MAX_SPEED: float = 500.0
const ACCEL: float = MAX_SPEED * 4
const DECEL: float = MAX_SPEED * 6

var current_speed: float = 0.0

@onready var interactor: Interactor = $Interactor

func _input(event: InputEvent) -> void:
	if not Game.player_can_control:
		return

	if event.is_action_pressed("interact"):
		Game.player_can_control = false
		await interactor.interact()
		Game.player_can_control = true

func _physics_process(delta: float) -> void:
	var direction_horizontal := Input.get_axis("move_left", "move_right")
	var direction_vertical := Input.get_axis("move_up", "move_down")

	if direction_horizontal and Game.player_can_control:
		velocity.x = move_toward(velocity.x, direction_horizontal * MAX_SPEED, ACCEL * delta)
		interactor.scale.x = -1 if direction_horizontal < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL * delta)

	if direction_vertical and Game.player_can_control:
		velocity.y = move_toward(velocity.y, direction_vertical * MAX_SPEED, ACCEL * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECEL * delta)

	if velocity.x != 0:
		for node in flip_nodes:
			node.scale.x = -1 if velocity.x < 0 else 1

	if velocity.x != 0 or velocity.y != 0:
		if animation_player.animation != "walk":
			animation_player.play("walk")
	else:
		if animation_player.animation != "idle":
			animation_player.play("idle")


	move_and_slide()


func _on_animated_sprite_2d_frame_changed() -> void:
	if animation_player.animation == "walk":
		if animation_player.frame in [4, 10]:
			walk_sfx.play()
