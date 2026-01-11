class_name Bullet
extends CharacterBody3D

@export var speed:float = 100
@export var damage:int = 1
@export var bullet_range:= 1000
var current_range:float
@onready var raycast: RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	
	var collider = raycast.get_collider()
	current_range += 1 * delta
	velocity = speed * global_basis.z
	if raycast.is_colliding() or current_range >= bullet_range:
		
		queue_free()
		
	move_and_slide()
