extends Node2D

@export var recepcionista_animation_player: AnimationPlayer
@export var slam_sfx: AudioStreamPlayer

@onready var recepcionista_entity: DialogEntity = preload("res://entities/recepcionista.tres")
@onready var bapo_entity: DialogEntity = preload("res://entities/bapo.tres")
@onready var shake_preset: ShakerPreset2D = preload("res://shakes/sleep_slam_shake.tres")

func _ready() -> void:
	recepcionista_entity.started_talking.connect(func():
		recepcionista_animation_player.play("talking")
	);

	recepcionista_entity.stopped_talking.connect(func():
		recepcionista_animation_player.stop()
	);

	if not Missions.initial_cutscene:
		Missions.initial_cutscene = true
		cutscene()
	else:
		recepcionista_animation_player.play("sleep")
		recepcionista_animation_player.seek(20)

func cutscene() -> void:
	Game.on_cutscene = true

	await Dialog.show_dialog(bapo_entity, "[snd 0]Olá! Gostaria de ofializar um documento, me recomendaram esse cartório, qual é o processo?")
	await Dialog.show_dialog(recepcionista_entity, "[snd 0]ah! nossa, eu nem te vi ai embaixo... bom, o processo é bem simples, só precisamos carimbar seu documento...")
	await Dialog.show_dialog(bapo_entity, "[snd 0]Ótimo! Aqui está o documento!")
	await Dialog.show_dialog(recepcionista_entity, "[snd 0]uhm... só tem um problema... o carimbo não está comigo... está com o chefe e ele não me devolveu até agora...")
	await Dialog.show_dialog(bapo_entity, "[snd 0]Eita, você acha que ele vai demorar pra devolver?")
	await Dialog.show_dialog(recepcionista_entity, "[snd 0]ah, não se preocupe, eu posso ir lá pegar para você, eu só preciso de alguns minutinhos...")

	var camera = get_viewport().get_camera_2d()
	Shaker.shake_by_preset(shake_preset, camera, 0.5, 2)
	slam_sfx.play()
	recepcionista_animation_player.play("sleep")

	await get_tree().create_timer(2).timeout

	await Dialog.show_dialog(bapo_entity, "[snd -1].[spd 0.01]...[snd 0][spd 1] Eu acho melhor eu ir atrás do carimbo...")

	Game.on_cutscene = false
