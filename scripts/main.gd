extends Node3D

@onready var cam : Camera3D = get_node("Camera3D")
@onready var marker : Marker3D = get_node("Marker3D")
@onready var pl : CharacterBody3D = get_node("player")


@export var rotation_dir:float 


func _process(_delta: float) -> void:
	move_cam()
	marker.global_position.x = pl.global_position.x
	marker.global_position.z = pl.global_position.z
	clamp(marker.global_rotation_degrees.x, PI/10,PI/10)

func move_cam():
	var dirx := Input.get_axis("sag","sol")
	var diry := Input.get_axis("yukari","asagi")
	marker.global_rotation_degrees.y += dirx * rotation_dir
	marker.global_rotation_degrees.x += diry *rotation_dir
	
