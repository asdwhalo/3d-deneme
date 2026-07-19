extends Control
@onready var begin_audio: AudioStreamPlayer = %beginAudio
@onready var config_audio: AudioStreamPlayer = %configAudio
@onready var exit_audio: AudioStreamPlayer = %exitAudio


func _on_begin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _exit_tree() -> void:
	
	queue_free()
func _on_config_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_begin_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_begin_button_mouse_exited() -> void:
	if begin_audio.get_parent() != owner:
		begin_audio.reparent(owner)
	begin_audio.play()


func _on_config_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_config_button_mouse_exited() -> void:
	if config_audio.get_parent() != owner:
		config_audio.reparent(owner)
	config_audio.play()


func _on_exit_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_exit_button_mouse_exited() -> void:
	if exit_audio.get_parent() != owner:
		exit_audio.reparent(owner)
	await get_tree().physics_frame
	exit_audio.play()
