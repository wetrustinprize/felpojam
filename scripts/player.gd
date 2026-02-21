extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_control: bool = true

@onready var interactor: Interactor = $Interactor

func _input(event: InputEvent) -> void:
	if not can_control:
		return

	if event.is_action_pressed("interact"):
		can_control = false
		await interactor.interact()
		can_control = true

func _physics_process(_delta: float) -> void:
	var direction_horizontal := Input.get_axis("move_left", "move_right")
	var direction_vertical := Input.get_axis("move_up", "move_down")

	if direction_horizontal and can_control:
		velocity.x = direction_horizontal * SPEED
		interactor.scale.x = -1 if direction_horizontal < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_vertical and can_control:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
