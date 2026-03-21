class_name Weapon
extends Resource


@export var Name:String = "empty"
@export var shoot_animation_name:String = "shoot"
@export var damage:float = 1.0
@export var scene:PackedScene = null
@export var shoot_position:Vector3
@export var anim_lib: AnimationLibrary
@export var bullet_scene : PackedScene
@export var shoot_point_array:Array[Vector3]

func _init() -> void:
	if bullet_scene == null: bullet_scene = load("res://scenes/bullet.tscn")
		
