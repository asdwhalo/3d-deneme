## Düğüm tabanlı silah sınıfı komplex silahlar için kullnanılır
class_name Gun
extends Node3D


@export var bullet:PackedScene
@export var anim_holder:AnimationPlayer
@export var ammo:int = 0 ## 0 ise mermi sınırsızdır

@export_subgroup("time related")
@export var cool_down_timer:Timer
@export var cool_down : float = 1
@export var alt_fire_timer:Timer
@export var alt_fire_cool_down:float
@export var time_to_ready_timer:Timer
@export var time_to_ready:float = 0
@export var max_swap : int = 0 ## 0 ise swaplama sonucunda cooldown olmaz

@onready var shoot_point : Node3D = $"../../shoot_point" ## GunManager ın shoot pointi

var can_fire:bool = true
var can_alt_fire:bool = true
var cur_ammo: = ammo
var swap_count:int

func fire() -> void:
    if !can_fire:
        return
    if ammo > 0:
        cur_ammo -= 1
    if max_swap != 0:
        swap_count += 1
func alt_fire() -> void:
    if !can_alt_fire:
        return
## Silahlar ele alındığında yani current olduklarında
func take() -> void:
    pass 
## silahlar elden bırakıldıklarında yani artık current olmadıklarında
func un_take() ->void:
    pass

## Mermi yenileme fonksiyonu
func reload() -> void:
    pass
## sway overloadı sıfırlar
func reload_swap() -> void:
    swap_count = 0
