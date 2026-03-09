extends Area3D
class_name Hitbox

@export var damage:float = 1.0
@export var coll:CollisionShape2D = null
@export var is_on:bool = true

#TODO TEST hasar sistemi 

func _process(_delta: float) -> void:
	monitoring = false if is_on == false else true
