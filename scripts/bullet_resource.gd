class_name BulletSource
extends Resource

@export var scene:PackedScene
@export var damage:float
@export var lifetime:float
@export var speed:float
@export var parry_able:bool
@export var behavior:Script
@export var type:Variant

enum bullet_type{
	NORMAL,
	RIGID
}

func _init() -> void:
	scene.set_script(behavior)  
