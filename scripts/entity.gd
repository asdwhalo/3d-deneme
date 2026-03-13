class_name Entity  ## hasar alabilen karakterlerin temeli
extends CharacterBody3D

#TODO modular hasar sistemi yaz AMK


@export var hp:float
@export var max_hp:float




var can_die:bool = true





signal is_dead
signal health_is_zero




func heal(amount:float) -> void:
	hp += amount

func take_damage(amount:float):

	hp -= amount

	if hp <= 0:
		health_is_zero.emit()

func on_zero_health():
	if can_die:
		is_dead.emit()


func on_dead():
	pass
