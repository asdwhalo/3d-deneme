class_name Bullet
extends CharacterBody3D

@export var damage:int = 1
@export var bullet_range:= 1000
@export var time_to_max_speed:float = 0.1
@export var normal_speed:float = 100
@export var starting_speed:float = 10

var speed:float
var current_range:float
var dir = 1
var timer:Timer

@onready var raycast: RayCast3D = $RayCast3D
@onready var particles: GPUParticles3D = $ammoparticels
func _ready() -> void:
	raycast.collide_with_areas = true
	if time_to_max_speed == 0:
		return
	else:
		timer = Timer.new()
		timer.wait_time = time_to_max_speed
		timer.one_shot = true
		timer.autostart = true
		timer.timeout.connect(on_timeout)
func _process(delta: float) -> void:
	var collider = raycast.get_collider()
	
	if particles.emitting == false :
		current_range += 1 * delta
		velocity =  transform.basis * Vector3(0,0,speed) 
	if raycast.is_colliding() or current_range >= bullet_range:
		particles.emitting = true
		if collider.has_method("take_damage"):
			print("hit")
			collider.take_damage(damage)
	move_and_slide()

func accel_bullet():
	if timer == null:
		speed = normal_speed
		return
	else:
		speed = starting_speed
		await timer.timeout
		speed = normal_speed


func _on_ammoparticels_finished() -> void:
	queue_free()


func on_timeout():
	timer.queue_free()
	timer.free()
