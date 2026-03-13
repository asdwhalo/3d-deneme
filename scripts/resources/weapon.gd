class_name Weapon
extends Resource


@export var Name:String = "empty"
@export var shoot_animation_name:String = "shoot"
@export var damage:float = 1.0
@export var scene:PackedScene = null
@export var shoot_position:Vector3
@export var anim_lib: AnimationLibrary
@export var ammo : PackedScene

func _init() -> void:
	if ammo == null: ammo = load("res://scenes/bullet.tscn")
		
