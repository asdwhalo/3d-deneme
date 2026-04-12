extends Control


func _on_begin_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/world.tscn")
	free()
func _exit_tree() -> void:
	
	queue_free()
func _on_config_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
