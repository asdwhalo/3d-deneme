## silahları kontrol eden sınıf

class_name GunManager
extends Node

#TODO Düğüm tabanlı ve kaynak tabanlı silah sistemlerini ayır

var current_state:weapon_state
var current_weapon_id:int = 0
var previus_weapon:Weapon
var previus_weapon_id:int
var weapon_scene
var is_attacking:bool = false


enum weapon_state {
	FIRE = 0,
	IDLE = 1,
	CHANGE = 2
}


@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var weapon_array:Array[Weapon]
@export var current_weapon:Weapon
@export var anim:AnimationPlayer
@export var parent : Player


var current_weapon_array:Array[Weapon]
var gun_array:Array = []
var current_gun:Gun
var current_gun_id:int = 0


@onready var shoot_point: Node3D = %shoot_point
@onready var hand_anims: AnimationPlayer = %hand_anims
#@onready var arm_sprite: Sprite2D = %armSprite
@onready var cool_down_timer: Timer = $coolDownTimer
@onready var times_on_attack_timer: Timer = $timesOnAttackTimer
@onready var gun_holder : Node = $gunHolder


func get_guns() -> void:
	gun_array = gun_holder.get_children()


## Node tabanlı silahları initler
func init_gun() ->void:
	if current_gun:
		current_gun.un_take()
	current_gun = gun_array[current_gun_id]
	current_gun.take()


## Resource tabanlı silah değiştirme fonksiyonu
func weapon_control() -> void:
	if Input.is_action_just_pressed("change"):
		if current_weapon_id == current_weapon_array.size() -1 :
			current_weapon_id = 0
			previus_weapon = current_weapon_array[current_weapon_array.size() -1]
			current_weapon = current_weapon_array[current_weapon_id]
			initilize_weapon()
			return
		previus_weapon = current_weapon_array[current_weapon_id]
		current_weapon_id += 1
		current_weapon = current_weapon_array[current_weapon_id]
	
		
		
	initilize_weapon()


func _ready() -> void:
	for resource in weapon_array:
		current_weapon_array.append(resource.duplicate())
		print(str(resource.cooldown))
	print(str(current_weapon_array[0].Name))
	
	current_weapon_id = 0
	current_weapon = current_weapon_array[current_weapon_id]
	initilize_weapon()
	
	cool_down_timer.wait_time = current_weapon.cooldown
	if current_weapon is MeleeWeapon:
		times_on_attack_timer.wait_time = current_weapon.times_on_attack 


#region bugged 
func change_weapon()->void:
	#TODO
	#numaralara basılınca  array da  o numaralara atanmış silah seçilir bu bir for döngüsüyle yazılacak
	# ancak şuanlık tektuş ile değiştirilcek
	if Input.is_action_just_pressed("change"):
		current_state = weapon_state.CHANGE
		if current_weapon == weapon_array[0]:
			current_weapon = weapon_array[1]
			initilize_weapon()
			current_state = weapon_state.IDLE
		else:
			current_weapon = weapon_array[0]
			initilize_weapon()
			current_state = weapon_state.IDLE


func init_vars():
	if current_weapon is FireArmWeapon:
		current_weapon.shoot_position = shoot_point.global_position
		current_weapon.shoot_position = shoot_point.global_position

## kaynak tabanlı silahları initleme fonksiyonu
func initilize_weapon() -> void:
	if weapon_scene:
		weapon_scene.queue_free()
	weapon_scene = current_weapon.scene.instantiate()
	init_vars()
	shoot_point.add_child(weapon_scene)
	if current_weapon.overide_swap == false: is_attacking = false
	cool_down_timer.wait_time = current_weapon.cooldown
	if current_state == weapon_state.CHANGE:
		weapon_scene.queue_free()
		init_vars()
		current_state = weapon_state.IDLE
#endregion


#firearm resourcunu düzenle (sadece şarjrü fln olsun mk)
func fire():
	if current_state == weapon_state.CHANGE:
		return

	elif Input.is_action_pressed("fire") and parent.is_cap and not is_attacking:
		cool_down_timer.start()
		if current_weapon:
				#if not anim == null or (!anim.is_playing() or anim.has_animation("shoot") and not anim.is_playing()):
					#
					#anim.play(current_weapon.shoot_animation_name) # tüm animasyonlar hand anims de tutulacak
				if current_weapon.shoot_point_array == null or current_weapon.shoot_point_array.size() <= 1:
					var bullet = current_weapon.bullet_scene.instantiate()
					add_child(bullet)
					bullet.global_transform.basis = shoot_point.global_transform.basis
					bullet.global_position = shoot_point.global_position
					is_attacking = true
					return
				else:
					for point in current_weapon.shoot_point_array:
						var bullet = current_weapon.bullet_scene.instantiate()
						owner.add_child(bullet)
						bullet.global_transform.basis = shoot_point.global_transform.basis
						bullet.global_position = point + shoot_point.global_position
					
					is_attacking = true
			
		

func _physics_process(_delta: float) -> void:
	#var weapon_scene = current_weapon.scene.instantiate()
	#if current_state == weapon_state.CHANGE:
		#weapon_scene.queue_free()
	weapon_control()
	fire()
	#change_weapon()


func _on_cool_down_timer_timeout() -> void:
	if cool_down_timer.is_stopped():
		is_attacking = false
	else:
		await cool_down_timer.timeout
		is_attacking = false
	is_attacking = false
