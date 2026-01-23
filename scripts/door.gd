extends CSGCombiner3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_on:bool = false
func  on_interac():
	if is_on == false:
		is_on = true
		animation_player.play("open")
		await animation_player.animation_finished
	else:
		is_on = true
		animation_player.play("close")
		await animation_player.animation_finished
