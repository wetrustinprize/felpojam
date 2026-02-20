extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var interactor: Interactor = $Interactor

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		interactor.interact()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction_horizontal := Input.get_axis("move_left", "move_right")
	var direction_vertical := Input.get_axis("move_up", "move_down")

	if direction_horizontal:
		velocity.x = direction_horizontal * SPEED
		interactor.scale.x = -1 if direction_horizontal < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_vertical:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
