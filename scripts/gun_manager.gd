class_name GunManager
extends Node

var current_state:weapon_state
enum weapon_state {
	IDLE,
	CHANGE
}
@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var gun_array:Array[Weapon]
@export var current_weapon:Weapon
@onready var shoot_point: Node3D = %shoot_point
@export var anim:AnimationPlayer
#@onready var anim: AnimationPlayer = current_weapon.ins_scene.get_node("basicPistol/AnimationPlayer")
@export var parent : Player 
func _ready() -> void:
	initilize_weapon()
func initilize_weapon() -> void:
	if current_weapon == null:
		current_weapon = load("res://scripts/resources/basic_pistol.tres")
	if current_weapon.shoot_position == Vector3(0,0,0):
		shoot_point.global_position = Vector3(0,-0.528,-1.014)
	else:
		shoot_point.global_position = current_weapon.shoot_position
	var weapon_scene = current_weapon.scene.instantiate()
	shoot_point.add_child(weapon_scene)
	if current_state == weapon_state.CHANGE:
		weapon_scene.queue_free()
		initilize_weapon()
func fire():
	var bullet = bullet_scene.instantiate()
	if Input.is_action_pressed("fire") and parent.is_cap:
		if  anim == null  or (!anim.is_playing() or anim.has_animation("shoot") and not anim.is_playing()):
			anim.play("shoot") # animasyon bulunamıyor 
			add_child(bullet)
			bullet.global_transform.basis = shoot_point.global_transform.basis
			bullet.global_position = shoot_point.global_position
func _physics_process(_delta: float) -> void:
	fire()
