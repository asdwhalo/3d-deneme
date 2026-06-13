extends Node3D

@onready var fade_rect = %ColorRect
@onready var fade_anim = $fadeRoot/AnimationPlayer

var faded:bool = false
var fading:bool = false
var global_delta:float = 0

func fade_screen() -> void:
    if fading == true:
        return
    if faded == true:
        fade_anim.play("defade")
    else :
        fade_anim.play("fade")

func _process(delta) -> void:
    global_delta = delta
