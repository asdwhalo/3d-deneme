class_name ArmManager
extends Node



@export var arms : Array[Arm] = []

@onready var parry_area : Area3D = %parryArea

@onready var parry_area_index:Array[Area3D] = parry_area.get_overlapping_areas()
var current_arm_id : int = 0
@export var current_arm:Arm = preload("res://scripts/arm_system/defalut.tres")
var is_arm_ready:bool = true



func punch() -> void:
	#if not is_arm_ready:
		#return 
	match current_arm.arm_name:
		"default":
			print("default arm")
			#if area_has_colided_with_parryable:
				#colided_area.parry()
			for object in parry_area.get_overlapping_areas():
				print("parry requested")
				if object is ParryableArea:
					object.parry()
					print("i parry" + str(object.parent.name))
				



func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("punch"):
		punch()
		print("punched")
var colided_area:ParryableArea = null
var area_has_colided_with_parryable:bool

#region that i started  because typo lol

func _on_parry_area_entered(area: Area3D) -> void:
	if area is ParryableArea:
		area_has_colided_with_parryable = true
		colided_area = area


func _on_parry_area_exited(area: Area3D) -> void:
	if area is ParryableArea:
		area_has_colided_with_parryable = false
		colided_area = null

#region end
