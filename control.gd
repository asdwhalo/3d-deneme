extends Control
@onready var begin_audio: AudioStreamPlayer = %beginAudio
@onready var config_audio: AudioStreamPlayer = %configAudio
@onready var exit_audio: AudioStreamPlayer = %exitAudio


func _on_begin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _exit_tree() -> void:
	
	queue_free()
func _on_config_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_begin_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_begin_button_mouse_exited() -> void:
	begin_audio.play()


func _on_config_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_config_button_mouse_exited() -> void:
	config_audio.play()


func _on_exit_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_exit_button_mouse_exited() -> void:
	exit_audio.play()
