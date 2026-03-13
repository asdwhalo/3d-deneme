extends CSGCombiner3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var is_on:bool = false

signal opened
signal closed

func  on_interac():
	if not timer.is_stopped():
		return
	if is_on == false:
		animation_player.play("open")
		timer.start()
		await timer.timeout
		is_on = true
	else:
		animation_player.play("close")
		timer.start()
		await timer.timeout
		is_on = false
