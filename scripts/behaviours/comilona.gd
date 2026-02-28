@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var comilona_animation: AnimationPlayer
@onready var comilona_entity = preload("res://entities/comilona.tres")

var animation_state: STATE = STATE.IRRITADA

enum STATE {
	IRRITADA,
	ALEGRE
}

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	comilona_entity.started_talking.connect(func():
		var animation: String

		match animation_state:
			STATE.IRRITADA:
				animation = "talking_angry"
			STATE.ALEGRE:
				animation = "talking_happy"

		comilona_animation.play("animation")
	);

	comilona_entity.stopped_talking.connect(func():
		comilona_animation.stop()
	);


func interact(_who: Interactor) -> void:
	Game.on_cutscene = true



	Game.on_cutscene = false
