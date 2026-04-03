extends Weapon
class_name FireArmWeapon


@export var max_ammo:int = 1


func _init() -> void:
	if bullet_scene == null: bullet_scene = load("res://scenes/bullet.tscn")
