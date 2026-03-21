class_name ParryableArea
extends Area3D

@export var parent:Node3D = get_parent()
@onready var player :Player = $/root/world/PlayerFps

func parry():
	if parent is Bullet:
		parent.damage *= 1.25
		parent.speed *= -2.0  if  parent.speed > 0.0 else 2.0
		parent.global_rotation = player.global_rotation
