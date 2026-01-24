class_name Weapon
extends Resource
@export var Name:String = "boş"
@export var damage:float = 1.0
@export var scene:PackedScene = null
@export var shoot_position:Vector3
#var anim = scene.get_node("AnimationPlayer")
var ins_scene:Node
#@export var anim:AnimationPlayer #resourceler bunu tutamıyor
func _init() -> void:
	#scene = ins_scene.instantiate()
	pass
