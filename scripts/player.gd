extends CharacterBody3D



#TODO  setget ekle!!!/ add setgets
@export var speed:float = 100
@export var can_move:bool = true
@export var jump_count:int = 1

@export var jump_height:float = 50

func move()->void:
	if not can_move:
		return
	var dir := Input.get_vector("d","a","s","w")
	var dirx = dir.x *speed * transform.basis.x
	var dirz = dir.y * speed * transform.basis.z
	var rot_dir = Input.get_axis("q","e")
	velocity = dirx + dirz
	global_rotation_degrees.y += rot_dir
#FIXME zıplama çalışmıyor!!! /its not jumping 
func jump()->void:
	var jp = Input.get_action_strength("space")
	velocity.y -= jump_height  * jp

func _process(_delta: float) -> void:
	move()
	move_and_slide()
func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("space"):
		jump()
		print("space")
