extends Weapon
class_name MeleeWeapon

@export var hitbox_shape:Shape3D
@export var times_on_attack:float = 1.0
@export var cooldown : float = 1.0
var is_on_attack :bool = false
var can_attack: bool = true
