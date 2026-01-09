class_name Item
extends RigidBody3D

@export var item_name:String = "empty"
@export var grabable:bool = false
signal graped
func _init() -> void:
	connect("graped",grap)
func grap():
	pass
