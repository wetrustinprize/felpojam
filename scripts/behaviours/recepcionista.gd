@tool
@icon("res://addons/plenticons/icons/16x/symbols/exclamation-mark-white.png")

extends Interactable

@export var recepcionista_animation_player: AnimationPlayer
@export var slam_sfx: AudioStreamPlayer
@export var door: Interactable

@onready var recepcionista_entity: DialogEntity = preload("res://entities/recepcionista.tres")
@onready var bapo_entity: DialogEntity = preload("res://entities/bapo.tres")
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

	await Dialog.show_dialog(bapo_entity, "Olá! Gostaria de ofializar um documento, me recomendaram esse cartório, qual é o processo?")
	await Dialog.show_dialog(recepcionista_entity, "ah! nossa, eu nem te vi ai embaixo... bom, o processo é bem simples, só precisamos carimbar seu documento...")
	await Dialog.show_dialog(bapo_entity, "Ótimo! Aqui está o documento!")
	await Dialog.show_dialog(recepcionista_entity, "uhm... só tem um problema... o carimbo não está comigo... está com o chefe e ele não me devolveu até agora...")
	await Dialog.show_dialog(bapo_entity, "Eita, você acha que ele vai demorar pra devolver?")
	await Dialog.show_dialog(recepcionista_entity, "ah, não se preocupe, eu posso ir lá pegar para você, eu só preciso de alguns minutinhos...")

	var camera = get_viewport().get_camera_2d()
	Shaker.shake_by_preset(shake_preset, camera, 0.5, 2)
	slam_sfx.play()
	recepcionista_animation_player.play("sleep")

	await get_tree().create_timer(2).timeout

	await Dialog.show_dialog(bapo_entity, "[snd -1].[spd 0.01]...[spd 1] Eu acho melhor eu ir atrás do carimbo...")

	Game.on_cutscene = false
	interactable = false
	door.interactable = true
