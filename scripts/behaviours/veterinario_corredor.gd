@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var veterinario_animation: AnimationPlayer
@export var veterinario_node: Node2D
@export var door_sfx: AudioStreamPlayer

@onready var veterinario_entity = preload("res://entities/veterinario.tres")

var anim_state: STATE = STATE.NORMAL

enum STATE {
	NORMAL,
	INJECAO,
	PRANCHETA,
}

func _ready() -> void:
	super._ready()

	interact_verb = "conversar"

	if Missions.veterinario_at_escritorio:
		veterinario_node.queue_free()
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

	if not Missions.first_veterinario_talk:
		Missions.first_veterinario_talk = true

		await Dialog.show_dialog(veterinario_entity, "Ah droga! Eu esqueci a injeção dele!")

		anim_state = STATE.PRANCHETA
		await Dialog.show_dialog(veterinario_entity, "Hm... Deixa eu ver aqui, ele ia tomar a injeção contra pulgas...")
		await Dialog.show_dialog(veterinario_entity, "Eu lembro de ter trazido ela aqui... Eu tava brincando com ela na recepção, quase me espetei com ela!")

		anim_state = STATE.NORMAL
		await Dialog.show_dialog(veterinario_entity, "Ah nossa! Eu nem perceib você ai embaixo! Você poderia fazer um favor pra mim e ver se eu deixei cair uma injeção na recepção né?")

		pass
	else:
		anim_state = STATE.NORMAL
		await Dialog.show_dialog(veterinario_entity, "Consegiu procurar na recepção a injeção? Eu não posso sair daqui senão se ele me ver ele vai fugir!")

	Game.on_cutscene = false
