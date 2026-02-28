@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var veterinario_animation: AnimationPlayer

@onready var veterinario_entity = preload("res://entities/veterinario.tres")

var anim_state: STATE = STATE.NORMAL

enum STATE {
	NORMAL,
	INJECAO,
	PRANCHETA,
}

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if not Missions.veterinario_at_escritorio:
		get_parent().queue_free()
		return

	veterinario_entity.started_talking.connect(func():
		var animation: String

		match anim_state:
			STATE.NORMAL:
				animation = "talking"
			STATE.INJECAO:
				animation = "talking_injecao"
			STATE.PRANCHETA:
				animation = "talking_prancheta"

		veterinario_animation.play(animation)
	);

	veterinario_entity.stopped_talking.connect(func():
		veterinario_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true

	await Dialog.show_dialog(veterinario_entity, "Bom, eu tive que usar um acalmente de leve nele, mas agora ele está vacinado!")

	Game.on_cutscene = false
