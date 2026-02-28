extends CanvasLayer

@export var item_control_scene: PackedScene

var items: Array[Item] = []
var old_items: Array[Item] = []

@onready var horizontal: HBoxContainer = $HBoxContainer
@onready var get_item_sfx: AudioStreamPlayer = $GetItemSFX
@onready var use_item_sfx: AudioStreamPlayer = $UseItemSFX

func add_item(item: Item):
	if item in items:
		printerr("item %s is already in the inventory" % item.name)
		return

	if not get_item_sfx.playing:
		get_item_sfx.play()

	items.append(item)
	old_items.append(item)
	_add_item_control(item)

func had_item(item: Item) -> bool:
	return old_items.has(item)

func has_item(item: Item) -> bool:
	return items.has(item)

func remove_item(item: Item):
	if not item in items:
		printerr("item %s is not in the inventory" % item.name)

	use_item_sfx.play()
	items.erase(item)
	_remove_item_control(item)

func _remove_item_control(item: Item):
	var control: Control = null

	for child in horizontal.get_children():
		if child.item == item:
			control = child
			break

	if control == null:
		printerr("No control for item %s" % item.name)
		return

	var tween: Tween = control.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(control, "custom_minimum_size:x", 0.0, 0.5)
	tween.tween_callback(control.queue_free)

func _add_item_control(item: Item):
	var control: Control = item_control_scene.instantiate()

	control.item = item
	var minSize = control.custom_minimum_size.x
	control.custom_minimum_size.x = 0

	horizontal.add_child(control)

	var tween: Tween = control.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(control, "custom_minimum_size:x", minSize, 0.5)
