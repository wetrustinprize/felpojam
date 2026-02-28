@tool
@icon("res://addons/plenticons/icons/16x/objects/door-open-white.png")

extends Interactable
class_name DoorInteractable

@export var room_scene: String
@export var current_scene: Node2D
@export var spawnpoint_name: String
@export var audio: AudioStreamPlayer = null

@onready var packed_scene: PackedScene = ResourceLoader.load("res://scenes/salas/" + room_scene + ".tscn", "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)

func _ready() -> void:
	super._ready()

	interact_verb = "entrar"

func interact(who: Interactor) -> void:
	if audio != null:
		audio.play()
	await Transition.transition_out(who.get_parent())

	var player = get_tree().get_nodes_in_group("Player")[0]

	var created_scene = packed_scene.instantiate()
	get_tree().root.add_child(created_scene)
	player.reparent(created_scene)

	await get_tree().process_frame
	var spawnpoint: Node2D = created_scene.get_node(spawnpoint_name)

	var level_info: LevelInfo = created_scene.get_node_or_null("LevelInfo")
	if level_info != null:
		level_info.apply_rules()

	var camera: Camera2D = player.get_node("Camera2D")
	camera.enabled = false

	await get_tree().create_timer(0.5).timeout

	player.velocity = Vector2.ZERO
	player.call_deferred("set_global_position", spawnpoint.global_position)

	camera.enabled = true

	current_scene.queue_free()

	await Transition.transition_in(player)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()

	if room_scene == null:
		warnings.append("There is no scene to load when entering this door")
	return warnings
