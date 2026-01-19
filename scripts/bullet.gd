class_name Bullet
extends CharacterBody3D

@export var speed:float = 100
@export var damage:int = 1
@export var bullet_range:= 1000
var current_range:float
@onready var raycast: RayCast3D = $RayCast3D
@onready var particles: GPUParticles3D = $ammoparticels

func _process(delta: float) -> void:
	var collider = raycast.get_collider()
	if particles.emitting == false:
		current_range += 1 * delta
		velocity =  transform.basis * Vector3(0,0,speed)
	if raycast.is_colliding() or current_range >= bullet_range:
		particles.emitting = true
		if collider.has_method("take_damage"):
			print("")
	move_and_slide()


func _on_ammoparticels_finished() -> void:
	queue_free()
