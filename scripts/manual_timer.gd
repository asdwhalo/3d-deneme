class_name ManualTimer
extends Node

@export var time_amount:float = 1
@export var re_start_at_end:bool = false
@export var ignore_time_scale:bool = false
@export var delta_scale:delta_present = delta_present.process

var time_left:float
enum delta_present{
    process,
    physic
}

static func _count_to_zero(delta:float,start_point:float):
    var timer = start_point
    pass