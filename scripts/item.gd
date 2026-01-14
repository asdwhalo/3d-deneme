class_name Item
extends RigidBody3D

@onready var ply = get_tree().get_first_node_in_group("player")
@export var item_name:String = "empty"
@export var grapable:bool = true
signal graped
func _init() -> void:
	connect("graped",grap)
	connect("taked",take)
func take():
	queue_free()
func grap():
	pass
func drop():
	pass
