class_name Weapon
extends Resource


@export var Name:String = "empty"
@export var shoot_animation_name:String = "shoot"
@export var damage:float
@export var scene:PackedScene = null
@export var cooldown : float = 0.5
@export var anim_lib: AnimationLibrary
@export var shoot_position:Vector3
@export var bullet_scene : PackedScene
@export var shoot_point_array:Array[Vector3]
