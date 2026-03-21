extends Entity 
class_name PlayerEntity

@export var max_iframes:float = 5.0
@export var hard_damage:float = 0
@onready var iframe_timer: Timer = Timer.new()

var on_iframe:bool
var max_hp_with_hard_damage : float = max_hp - hard_damage 
var damage:float = 0.0
func on_iframe_ended():
	on_iframe = false


func _ready() -> void:
	is_dead.connect(on_dead)
	health_is_zero.connect(on_zero_health)
	iframe_timer.wait_time = max_iframes
	iframe_timer.one_shot = true
	iframe_timer.timeout.connect(on_iframe_ended)
	
	
func take_damage(amount:float):
	if not on_iframe:
		return
	super.take_damage(damage)
	print("damaged")
	damage = 0.0
	on_iframe = true
	iframe_timer.start()
