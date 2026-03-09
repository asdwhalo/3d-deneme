extends Area3D
class_name Hurtbox

@export var parent:Entity = get_parent()
@export var max_iframes:float = 5.0

@onready var iframe_timer: Timer = Timer.new()

var on_iframe:bool



func _init() -> void:
	iframe_timer.wait_time = max_iframes
	iframe_timer.one_shot = true
	iframe_timer.timeout.connect(on_iframe_ended)
	
	connect("area_entered",on_hit)
	#connect("area_entered",parent.take_damage)


func on_iframe_ended():
	on_iframe = false


func _process(delta:float):
	pass


func on_hit(area:Area3D):
	if area is not Hitbox  or not on_iframe:
		return
	parent.take_damage(area.damage)
	on_iframe = true
	iframe_timer.start()
