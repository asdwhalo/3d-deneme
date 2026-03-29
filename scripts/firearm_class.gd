extends Weapon
class_name FireArmWeapon

@export var shoot_position:Vector3
@export var bullet_scene : PackedScene
@export var shoot_point_array:Array[Vector3]
func _init() -> void:
	if bullet_scene == null: bullet_scene = load("res://scenes/bullet.tscn")
