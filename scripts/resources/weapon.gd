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
@export var can_quickswap:bool = false
@export var is_quickswaped:bool = true
@export var time_to_be_quickswap:float = 0
@export var quickswap_count:int = 0
@export var max_quick_swap:int = -1 
@export var quickswap_cooldown:float = 0
@export var take_time:float = 0.1
@export var time_left:float = 0
@export var input_for_alt:AltInputType = AltInputType.per_click
@export var bullet_type:AltBulletType

enum AltInputType {
	hold,
	per_click
}

#TODO
enum AltBulletType{
	
	
}
