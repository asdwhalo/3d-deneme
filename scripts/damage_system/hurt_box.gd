extends Area3D
class_name Hurtbox

@export var parent:Entity = get_parent()
@export var max_iframes:float = 5.0

@onready var iframe_timer: Timer = Timer.new()

var on_iframe:bool



func _ready() -> void:
	iframe_timer.wait_time = max_iframes
	iframe_timer.one_shot = true
	iframe_timer.timeout.connect(on_iframe_ended)
	
	connect("area_entered",on_hit)
	#connect("area_entered",parent.take_damage)


func on_iframe_ended():
	on_iframe = false


func on_hit(area:Area3D):
	if area is  Hitbox:
		if parent is PlayerEntity:
			parent.damage = area.damage
			parent.take_damage(parent.damage)
		parent.take_damage(area.damage)
