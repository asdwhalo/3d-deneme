class_name Player
extends PlayerEntity

## FPS player base
#signal dead
#TODO item +alma +yakalama +bırakma ve ~çekme  sistemi yaz +giti ayarla+ FIXME merminin oyuncunun baktığı yöne dönme sini sağla
#TODO  ##+merdiven basamak fiziklerini+ ekle ve +eğilmeyi düzelt##
#TODO noclip ve debug kameraları ekle
#TODO mermileri düzelt +grap sistemini düzelt
#TODO ~eşya fiziklerini onar 
#TODO durdurma menüsünü yap silah kamerası yap
#TODO modüler silah sistemleri yaz
#TODO basit head bob ekle
#TODO oyuncu için bir model oluştur ve bu modeli ekle saldırılar da ekle
#TODO tırmanma ve ~etkileşim ekle 
#TODO Karakterin boyutlarını kapıdan geçebilecek şekilde ayarla
@export var invertory:Array = []
@export var is_cap:bool = true
@export var states:sts 
@export var Mstates:stsm
@export var current_speed:float = 5.0
@export var walk_speed:float = 5.0
@export var crounch_speed:float = 3.0
@export var run_speed:float = 7.0
@export var slowing_speed:float = 0.5
@export var jump_velocity:float = 4.5
@export var mouse_sensivity:float = 0.3
@export var slam_multiper:float = 1
@export var is_bobable:bool = true
@export var can_climb:bool = false
@export var lerp_value:float = 0.5
@export var can_lerp:bool = true
@export var dash_cooldown:float = 1.0
@export var dash_count:int = 3
@export var max_dash_count:int = 3
@onready var particels: GPUParticles3D = $GPUParticles3D
#@onready var hand: Node3D = %hand
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast3D = %RayCast3D
@onready var hud: Control = %hud
@onready var grap_point: Node3D = $neck/head/grapPoint
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var shoot_point : Node3D = $neck/head/shoot_point
@onready var slowing_timer: Timer = $slowingTimer
@onready var parry_timer: Timer = $parryTimer
@onready var dash_timer: Timer = $dashTimer

#@onready var ground_check :RayCast3D= $groundCheck
#@onready var is_on_ground :bool = ground_check.is_colliding() and ground_check.get_collider() is not Player
var input_dir:Vector2
var info_text:String = ""
var current_gravity:float
var is_slowing:bool = false
var is_dash_loading:bool = false
var previus_speed:float:
	get:
		if Engine.get_physics_frames() % 2 == 0:
			return current_speed
		else:
			return current_speed
var mass:float = 1
var player_delta:float = 0
var direction := Vector3.ZERO
var height_tween:Tween
var speed_tween:Tween
var previus_dir:Vector2 :
	get:
		if Engine.get_physics_frames() % 2 == 0:
			return input_dir
		else:
			return input_dir
@onready var stair_check: CollisionShape3D = $stair_check
@onready var stair_check_2: CollisionShape3D = $stair_check2
@onready var stair_check_3: CollisionShape3D = $stair_check3
@onready var stair_check_4: CollisionShape3D = $stair_check4
@onready var stair_check_5: CollisionShape3D = $stair_check5
@onready var stair_check_6: CollisionShape3D = $stair_check6
@onready var stair_check_7: CollisionShape3D = $stair_check7
@onready var stair_check_8: CollisionShape3D = $stair_check8
@onready var dash_pos: Node3D = %dashPos
@onready var spring_arm: SpringArm3D = $dashRoot/springarm
@onready var crounch_ray: RayCast3D = $CrounchRay
@onready var fps_label: Label = $neck/head/Camera3D/CanvasLayer/hud/fpsLabel

@onready var dash_tweener:Tween

@onready var stair_check_array = [stair_check,stair_check_2,stair_check_3,stair_check_4,stair_check_5,stair_check_6,stair_check_7,stair_check_8]
@onready var model_head : MeshInstance3D = $player_model/head

@onready var crouch_height_checker: RayCast3D = %crouchHeightChecker

const default_head_y = 1.536
const normal_height := 1.7
const cruch_height := 1.3



@onready var head: Node3D = %head
@onready var neck: Node3D = $neck
@onready var coll: CollisionShape3D = %upper
@onready var lower: CollisionShape3D = %lower
@onready var mesh: MeshInstance3D = %MeshInstance3D


#			TODO
# daha sulu bir sistem yaz
# eğilmeyi iyileştir
# animasyolar ekle


signal dash


enum sts{
	HAVA,
	YER
}
enum stsm{
	RUN,
	WALK,
	CROUCH,
	Slide
}
#ön dash posu düzelt
func calc_dash_pos():
	if Input.is_action_pressed("w"):
		spring_arm.rotation.y = deg_to_rad(180)
		
	elif Input.is_action_pressed("s"):
		spring_arm.rotation.y = deg_to_rad(0)
		
	elif Input.is_action_pressed("a"):
		spring_arm.rotation.y = deg_to_rad(-90)
		
	elif Input.is_action_pressed("d"):
		spring_arm.rotation.y = deg_to_rad(90)
	else:
		spring_arm.rotation.y = deg_to_rad(180)
		
func _ready() -> void:
	dash.connect(dash_to_dash_pos)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	
func bobbed_y(multipler:float = 1)-> float:
	return sin(multipler * (10 * global_position.x))
func head_bob():
	if !is_bobable:
		return
	head.position.y = bobbed_y() + default_head_y
func Mstate_manager():
	if Input.is_action_just_pressed("run"):
		dash.emit()
		print("dash_request")
	elif Input.is_action_pressed("run"):
		Mstates = stsm.RUN
	elif Input.is_action_pressed("crouch"):
		Mstates = stsm.CROUCH
	elif crounch_ray.is_colliding() == false:
		Mstates = stsm.WALK
func dash_to_dash_pos():
	if not can_dash():
		print("out of dash")
		return
	if dash_tweener:dash_tweener.kill()
	dash_tweener =  create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	dash_tweener.tween_property(self,"global_position",dash_pos.global_position,0.1)
	print("dashed")
	dash_count -= 1
	await dash_timer.timeout
	dash_count += 1


func dash_control():
	if not dash_count == max_dash_count:
		dash_timer.start()
	else:
		dash_timer.stop()
	
	

func can_dash():
	if dash_count == 0:
		return false
	else:
		return true


func change_stateM(new_state:stsm)-> void:
	var old_state := Mstates
	Mstates = new_state
	match old_state:
		stsm.RUN:
			pass
		stsm.WALK:
			pass
		stsm.CROUCH:
			if new_state != stsm.CROUCH and crouch_height_checker.is_colliding():
				coll.shape.height =  cruch_height + abs(crouch_height_checker.get_collision_point().y) - crouch_height_checker.global_position.y
				mesh.mesh.height = cruch_height + abs(crouch_height_checker.get_collision_point().y) - crouch_height_checker.global_position.y
			else:
				#coll.shape.height = normal_height
				#mesh.mesh.height = normal_height
				pass
	match new_state:
		stsm.RUN:
			if not crounch_ray.is_colliding():
				current_speed = walk_speed#run_speed
				coll.shape.height = normal_height
				mesh.mesh.height = normal_height
				mass = 0.3
			else:
				if height_tween:height_tween.kill()
				height_tween = create_tween()
				height_tween.set_parallel(true)
				height_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
				height_tween.tween_property(self,"current_speed",crounch_speed,0.05)
				height_tween.tween_property(self,"coll:shape:height",cruch_height,0.05)
				height_tween.tween_property(self,"mesh:mesh:height",cruch_height,0.05)
		stsm.WALK:
			if not crounch_ray.is_colliding():
				current_speed = walk_speed
				coll.shape.height = normal_height
				mesh.mesh.height = normal_height
				mass = 1.25
			else:
				if height_tween:height_tween.kill()
				height_tween = create_tween()
				height_tween.set_parallel(true)
				height_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
				height_tween.tween_property(self,"current_speed",crounch_speed,0.05)
				height_tween.tween_property(self,"coll:shape:height",cruch_height,0.05)
				height_tween.tween_property(self,"mesh:mesh:height",cruch_height,0.05)
		stsm.CROUCH:
			if height_tween:height_tween.kill()
			height_tween = create_tween()
			height_tween.set_parallel(true)
			height_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
			height_tween.tween_property(self,"current_speed",crounch_speed,0.05)
			height_tween.tween_property(self,"coll:shape:height",cruch_height,0.05)
			height_tween.tween_property(self,"mesh:mesh:height",cruch_height,0.05)
			#current_speed = crounch_speed
			#coll.shape.height = cruch_height
			#mesh.mesh.height = cruch_height
			mass = 2
		stsm.Slide:
			current_speed = 10
			coll.shape.height = cruch_height
			mesh.mesh.height = cruch_height
			if Input.is_action_just_released("crouch"):
				change_stateM(stsm.WALK)
var collider
func stair_control():
	if !can_climb:
		return
	for ray in stair_check_array:
		if  Mstates == stsm.CROUCH: # states == sts.HAVA or
			ray.disabled = true
			continue
		else:
			ray.disabled = false

func set_info_text() ->void:
	var collider = raycast.get_collider() as Node3D
	
	if raycast.is_colliding() == false:
		info_text = "+"
		return
	else:
		if collider.has_node("Namer"):
			info_text = str(collider.get_node("Namer").Name)
		elif collider.has_meta("name"):
			info_text = collider.get_meta("name")
		
			

func hudControl()->void:

#	if invertory[1] == null:
#		hud.inventory.text = "empty"
#	else:
#		hud.inventory.text = str(invertory[0])
	#var input_dir := Input.get_vector("a", "d", "w", "s")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	collider = raycast.get_collider() as Node3D
	#var collide_point = raycast.get_collision_point()
	#grap_point.global_position = collide_point.global_position
	hud.speed.text = str(velocity.x)
	hud.is_ground.text = str(is_on_floor())
	if not raycast.is_colliding():
		hud.info.text = "+"
	else:
		if collider is Item:
			info_text = str(collider.item_name)
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
				else:
					collider.drop()
		elif collider.has_node("Namer"):
			print("oha" + str(collider))
			info_text =  str(collider.get_node("Namer").Name)
		elif collider.has_node("$interacableArea3D") != null or collider is interacableArea3D:
			if Input.is_action_just_pressed("interac") and collider.has_signal("on_interac"):
				print("interac object found and request input")
				collider.on_interac.emit()
			
			if Input.is_action_just_released("interac") and collider is Item and collider.has_method("drop"):
				collider.drop()
		#elif collider.has_method("on_interac"):
			#if Input.is_action_just_pressed("interac"):
				#collider.on_interac() # çalışıyor
		else:
			hud.info.text = "+"
		if collider != null and collider.has_meta("name") and collider is not Item:
			info_text = str(collider.get_meta("name"))
		else:
			info_text = "+"
	
func get_interac(object:Node3D)->void:
	if not object.has_signal(object.on_interac) or not object.has_method(object.on_interac) :
		return
	if object.has_signal(object.on_interac):
		object.on_interac.emit()
		return
	object.on_interac()
func fire():
	if self.has_node("Components/gun_manager"):
		return
	var bullet = bullet_scene.instantiate()
	if Input.is_action_pressed("fire") and is_cap:
		if !anim.is_playing():
			anim.play("shoot")
			add_child(bullet)
			bullet.global_transform.basis = shoot_point.global_transform.basis
			bullet.global_position = shoot_point.global_position
func state_manager():
	if is_on_floor():
		states = sts.YER
	elif not is_on_floor():
		states = sts.HAVA
func cap_mouse()->void:
	if is_cap:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func tween_denemesi():
	var _tween = self.create_tween()
	@warning_ignore("unused_variable")
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
	var basis_x: Vector3 = Vector3(1,0,0)
	cap_mouse()
	if  is_cap == true:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion :
			if  not Mstates == stsm.Slide:
				self.rotate_y(deg_to_rad(event.relative.x *-mouse_sensivity))
			else:
				neck.rotate_y(deg_to_rad(event.relative.x *-mouse_sensivity))
			head.rotate_x(deg_to_rad(event.relative.y *-mouse_sensivity))
			
			head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(90))
	else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pass



func _physics_process(delta: float) -> void:
	fps_label.text = str(int(Engine.get_frames_per_second()))
	dash_count = clamp(dash_count,0,max_dash_count)
	player_delta = delta
	#dash_control()
	calc_dash_pos()
	input_dir = Input.get_vector("a", "d", "w", "s")
	model_head.global_rotation = head.global_rotation
	fire()
	head_bob()
	stair_control()
	hudControl()
	set_info_text()
	if current_speed >= 6 and states == sts.YER and input_dir:
		particels.emitting = true
	else:
		particels.emitting = false
	
	state_manager()
	Mstate_manager()
	
	if Input.is_action_pressed("run"):
		change_stateM(stsm.RUN)
		if Input.is_action_just_pressed("crouch"):
			change_stateM(stsm.Slide)
		#current_speed = run_speed
		#coll.shape.height = normal_height
		#mesh.mesh.height = normal_height
	elif Input.is_action_pressed("crouch"):
		change_stateM(stsm.CROUCH)
		#current_speed = crounch_speed
		#coll.shape.height = cruch_height
		#mesh.mesh.height = cruch_height
		if states == sts.HAVA:
			slam_multiper = 3
		elif states == sts.YER:
			slam_multiper = 1
	elif Input.is_action_just_released("crouch"):
		#if Mstates != stsm.CROUCH and crouch_height_checker.is_colliding():
				#coll.shape.height =  cruch_height - (crouch_height_checker.get_collision_point().y)
				#mesh.mesh.height = cruch_height - (crouch_height_checker.get_collision_point().y)
		#if Mstates != stsm.CROUCH and crouch_height_checker.is_colliding():
			#coll.shape.height =  cruch_height + abs(crouch_height_checker.get_collision_point().y) - crouch_height_checker.global_position.y
			#mesh.mesh.height = cruch_height + abs(crouch_height_checker.get_collision_point().y) - crouch_height_checker.global_position.y
		pass
	else:
		change_stateM(stsm.WALK)
		#current_speed = walk_speed
		#coll.shape.height = normal_height
		#mesh.mesh.height = normal_height
		#slam_multiper = 1
	if states == sts.HAVA:
		velocity += get_gravity() * mass * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and states == sts.YER:
		velocity.y = jump_velocity
		$jump_particels.emitting = true
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_lerp:
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_value)
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed #if not is_slowing else slowing_speed
		velocity.z = direction.z * current_speed #if not is_slowing else slowing_speed
	else:
		is_slowing = true
		if states == sts.HAVA:
			if can_lerp:
				current_speed = lerp(current_speed,0.0,lerp_value*0.1*delta)
			else:
				current_speed *= -cos(velocity.y) #sin(walk_speed/5) #/ cos(velocity.y)
			
			#await get_tree().create_timer(0.1).timeout
			#velocity.y = current_gravity * cos(velocity.x * 5)
		else:
			if speed_tween:speed_tween.kill()
			speed_tween = create_tween()
			speed_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
			speed_tween.tween_property(self,"velocity:x",0,0.05)
			#velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)
	#if input_dir == Vector2.ZERO:
		#input_dir = Vector2.ONE
		#slowing_timer.start()
		#is_slowing = true
	
	move_and_slide()
func _on_slowing_timer_timeout() -> void:
	is_slowing = false


func _on_dash_timer_timeout() -> void:
	dash_count += 1 if dash_count != max_dash_count else 0
	
	
