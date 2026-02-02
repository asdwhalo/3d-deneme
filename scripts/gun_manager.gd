class_name GunManager
extends Node

#FIXME silahlar değişmiyor

var current_state:weapon_state
enum weapon_state {
	IDLE,
	CHANGE
}
@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var weapon_array:Array[Weapon]
@export var current_weapon:Weapon
@onready var shoot_point: Node3D = %shoot_point
@export var anim:AnimationPlayer
#@onready var anim: AnimationPlayer = current_weapon.ins_scene.get_node("basicPistol/AnimationPlayer")
@export var parent : Player 
func _ready() -> void:
	initilize_weapon()
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
		current_weapon.shoot_position = shoot_point.global_position
		
func initilize_weapon() -> void:
	var weapon_scene = current_weapon.scene.instantiate()
	init_vars()
	shoot_point.add_child(weapon_scene)
	if current_state == weapon_state.CHANGE:
		weapon_scene.queue_free()
		init_vars()
		current_state = weapon_state.IDLE
#endregion 
func fire():
	if current_state == weapon_state.CHANGE:
		return
	var bullet = bullet_scene.instantiate()
	if Input.is_action_pressed("fire") and parent.is_cap:
		if  anim == null  or (!anim.is_playing() or anim.has_animation("shoot") and not anim.is_playing()):
			anim.play("shoot") # animasyon bulunamıyor 
			add_child(bullet)
			bullet.global_transform.basis = shoot_point.global_transform.basis
			bullet.global_position = shoot_point.global_position
func _physics_process(_delta: float) -> void:
	var weapon_scene = current_weapon.scene.instantiate()
	if current_state == weapon_state.CHANGE:
		weapon_scene.queue_free()
	fire()
	change_weapon()
