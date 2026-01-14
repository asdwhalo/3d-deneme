class_name Player
extends CharacterBody3D

## FPS player base
#signal dead
#TODO item +alma +yakalama +bırakma ve çekme  sistemi yaz giti ayarla+ FIXME merminin oyuncunun baktığı yöne dönme sini sağla
#TODO  merdiven basamak fiziklerini ekle
#TODO noclip ve debug kameraları ekle
#TODO mermileri düzelt garp sistemini düzelt
#TODO eşya fiziklerini onar 

@export var invertory:Array = []
@export var is_cap:bool = true
@export var states:sts 
@export var Mstates:stsm
@export var current_speed:float = 5.0
@export var  walk_speed:float = 5.0
@export var crounch_speed:float = 3.0
@export var run_speed:float = 7.0
@export var jump_velocity:float = 4.5
@export var mouse_sensivity:float = 0.3
@export var slam_multiper:float = 1
@onready var particels: GPUParticles3D = $GPUParticles3D
#@onready var hand: Node3D = %hand
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast3D = $head/RayCast3D
@onready var hud: Control = %hud
@onready var grap_point: Node3D = $head/grapPoint
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var shoot_point : Node3D = $head/shoot_point

var current_gravity:float


@onready var head: Node3D = %head
@onready var coll: CollisionShape3D = %upper
@onready var lower: CollisionShape3D = %lower

@onready var mesh: MeshInstance3D = %MeshInstance3D
#@onready var gun: Node3D = %gun_display

#			TODO
# daha sulu bir sistem yaz
# eğilmeyi iyileştir
# animasyolar ekle
# 
# silah silah sistemi ekle



enum sts{
	HAVA,
	YER
}
enum stsm{
	RUN,
	WALK,
	CROUCH
}

const normal_height := 2.0
const cruch_height := 1.3


func Mstate_manager():
	if Input.is_action_pressed("run"):
		Mstates = stsm.RUN
	elif Input.is_action_pressed("crouch"):
		Mstates = stsm.CROUCH
	else:
		Mstates = stsm.WALK

func hudControl()->void:
#	if invertory[1] == null:
#		hud.inventory.text = "empty"
#	else:
#		hud.inventory.text = str(invertory[0])
	#var input_dir := Input.get_vector("a", "d", "w", "s")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var collider = raycast.get_collider()
	#var collide_point = raycast.get_collision_point()
	#grap_point.global_position = collide_point.global_position
	hud.speed.text = str(velocity.x)
	hud.is_ground.text = str(is_on_floor())
	if not raycast.is_colliding():
		hud.info.text = "+"
		return
	else:
		if collider is Item:
			hud.info.text = str(collider.item_name)
			if Input.is_action_pressed("interac"):
				if collider.grapable == false:
					if collider.has_method("take"):
						collider.take()
				#refaktor yap
				elif collider.has_method("grap"):
					if collider.pullable_on_x == true:
						collider.global_position.x = grap_point.global_position.x
					elif collider.pullable_on_y == true:
						collider.global_position.y = grap_point.global_position.y
					elif collider.pullable_on_z == true:
						collider.global_position.z = grap_point.global_position.z
					elif collider.ground_only == true:
						collider.global_position.x = grap_point.global_position.x
						collider.global_position.z = grap_point.global_position.z
					else:
						collider.global_position = grap_point.global_position
						collider.grap()
					#if Input.is_action_just_pressed("interac"):
					#	collider.drop()
					
		else:
			hud.info.text = "+"
		if collider != null and collider.has_meta("name") and collider is not Item:
			hud.info.text = str(collider.get_meta("name"))
		else:
			hud.info.text = "+"
		
	
	
func fire():
	var bullet = bullet_scene.instantiate()
	if Input.is_action_just_pressed("fire"):
		add_child(bullet)
		bullet.global_rotation = -shoot_point.global_rotation * shoot_point.global_basis.z + shoot_point.global_basis.x
		#bullet.global_rotation.x = -shoot_point.global_rotation.x
		#bullet.global_rotation_degrees = -head.global_rotation_degrees * head.global_basis
		bullet.global_position = shoot_point.global_position
func state_manager():
	if self.is_on_floor():
		states = sts.YER
	elif not self.is_on_floor():
		states = sts.HAVA
func cap_mouse()->void:
	if is_cap:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func tween_denemesi():
	var _tween = self.create_tween()
	var degress:int = 10
	#gun.rotation.x = lerp_angle(deg_to_rad(degress),deg_to_rad(-degress),1)
	
	
	#tween.tween_property(gun,"rotation",Vector3(deg_to_rad(degress),0,0),2)
	#tween.tween_property(gun,"rotation",Vector3(deg_to_rad(-degress),0,0),2)
	match Mstates:
		stsm.RUN:
			degress = 10
		stsm.WALK:
			degress = 5
		stsm.CROUCH:
			degress = 2
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(event.relative.x *-mouse_sensivity))
		head.rotate_x(deg_to_rad(event.relative.y *-mouse_sensivity))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(90))
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("a", "d", "w", "s")
	# Add the gravity.
	fire()
	hudControl()
	if current_speed >= 6 and is_on_floor() and input_dir:
		particels.emitting = true
	else:
		particels.emitting = false
	cap_mouse()
	state_manager()
	Mstate_manager()
	
	if Input.is_action_pressed("run"):

		current_speed = run_speed
		coll.shape.height = normal_height
		mesh.mesh.height = normal_height
	elif Input.is_action_pressed("crouch"):
		current_speed = crounch_speed
		coll.shape.height = cruch_height
		mesh.mesh.height = cruch_height
		if states == sts.HAVA:
			slam_multiper = 3
		elif states == sts.YER:
			slam_multiper = 1
	else:
		current_speed = walk_speed
		coll.shape.height = normal_height
		mesh.mesh.height = normal_height
		slam_multiper = 1
	if not is_on_floor():
		velocity += get_gravity() * slam_multiper * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump_velocity
		$jump_particels.emitting = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
