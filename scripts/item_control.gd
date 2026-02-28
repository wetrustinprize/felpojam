@tool

extends Control
class_name ItemControl

@export var item_texture: TextureRect
@export var item_label: Label
@export var item: Item = null:
	set(value):
		item = value
		pass
