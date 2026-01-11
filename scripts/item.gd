class_name Item
extends RigidBody3D

@onready var ply = get_tree().get_first_node_in_group("player")
@export var item_name:String = "empty"
@export var grabable:bool = false
signal graped
func _init() -> void:
	connect("graped",grap)
func grap():
	print("you take "+str(item_name)+" taken")
	#ply.inventory.append(item_name)
	queue_free()
