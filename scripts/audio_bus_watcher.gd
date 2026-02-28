extends Node

@export var bus: StringName
@export var slider: Slider
@export var label_percentage: Label
@export var bus_test_sfx: AudioStreamPlayer

@onready var bus_id = AudioServer.get_bus_index(bus)

func _ready() -> void:
	slider.step = 0.01
	slider.min_value = 0.0
	slider.max_value = 1.0

	slider.value = AudioServer.get_bus_volume_linear(bus_id)
	_update_text()

	slider.value_changed.connect(func(value: float):
		AudioServer.set_bus_volume_linear(bus_id, value)
		_update_text()

		bus_test_sfx.stop()
		bus_test_sfx.bus = bus
		bus_test_sfx.play()
	)

func _update_text() -> void:
	label_percentage.text = "%d%%" % (AudioServer.get_bus_volume_linear(bus_id) * 100.0)
