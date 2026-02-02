class_name Entity
extends CharacterBody3D

#TODO modular hasar sistemi yaz AMK


@export var hp:float
signal is_dead


func _init() -> void:
	is_dead.connect(on_dead)


func take_damage(amount:float):
	hp -= amount


func on_dead():
	pass
