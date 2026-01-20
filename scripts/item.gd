class_name Item
extends RigidBody3D

@onready var ply = get_tree().get_first_node_in_group("player")
@export var item_name:String = "empty"
@export var grapable:bool = true
@export var pullable_on_x:bool
@export var pullable_on_y:bool
@export var pullable_on_z:bool
@export var ground_only:bool

signal graped
signal taked
func _init() -> void:
	connect("graped",grap)
	connect("taked",take)
func take():
	queue_free()
func grap():
	freeze = true
func drop():
	freeze = false
