@icon("res://addons/plenticons/icons/16x/creatures/person-white.png")

extends Resource
class_name DialogEntity

@export var portrait: Texture2D
@export var sounds: Array[AudioStream]
@export var name: String

signal started_talking
signal stopped_talking
