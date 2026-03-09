class_name HealthManager
extends Node

@export var parent:Entity
@export var standart_hp:float = 0

signal health_is_zero


func ready()->void:
	parent.hp = standart_hp
func _physics_process(delta: float) -> void:
	if parent.hp <= 0:
		health_is_zero.emit()
