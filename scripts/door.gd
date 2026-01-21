extends CSGCombiner3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_on:bool = false
func  on_interac():
	if is_on == false:
		animation_player.play("open")
		await animation_player.animation_finished
		is_on = true
		return
	animation_player.play("close")
	await animation_player.animation_finished
	is_on = true
