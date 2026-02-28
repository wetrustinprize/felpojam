@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var recepcionista_animation_player: AnimationPlayer
@export var slam_sfx: AudioStreamPlayer
@export var door: Interactable

@onready var recepcionista_entity: DialogEntity = preload("res://entities/recepcionista.tres")
@onready var shake_preset: ShakerPreset2D = preload("res://shakes/sleep_slam_shake.tres")

func _ready() -> void:
	super._ready()

	if Engine.is_editor_hint():
		return

	interact_verb = "conversar"

	if Missions.initial_cutscene:
		recepcionista_animation_player.play("sleep")
		recepcionista_animation_player.seek(20)
		door.interactable = true
		interactable = false

func interact(_who: Interactor) -> void:
	if Missions.initial_cutscene:
		return

	Missions.initial_cutscene = true
	Game.on_cutscene = true

	await Dialog.show_dialog(recepcionista_entity, "ah! nossa, eu nem te vi ai embaixo... você quer assinar um documento?")

	await Dialog.show_dialog(recepcionista_entity, "bom, o processo é bem simples, só precisamos carimbar seu documento...")
	await Dialog.show_dialog(recepcionista_entity, "uhm... só tem um problema... o carimbo não está comigo... está com o chefe...")
	await Dialog.show_dialog(recepcionista_entity, "sabe, eu ando muita cansada ultimamente... você poderia fazer o favor pra mim e ir lá pegar né?")
	await Dialog.show_dialog(recepcionista_entity, "enquanto isso, eu posso terminar os meus deveres mega importantes aqui...")

	var camera = get_viewport().get_camera_2d()
	Shaker.shake_by_preset(shake_preset, camera, 0.5, 2)
	slam_sfx.play()
	recepcionista_animation_player.play("sleep")

	await get_tree().create_timer(2).timeout

	Game.on_cutscene = false
	interactable = false
	door.interactable = true
