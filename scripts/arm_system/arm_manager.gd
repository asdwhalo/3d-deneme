class_name ArmManager
extends Node



@export var arms : Array[Arm] = []

@onready var parry_area : Area3D = %parryArea

var current_arm_id : int = 0
var current_arm:Arm

func punch() -> void:
	pass
