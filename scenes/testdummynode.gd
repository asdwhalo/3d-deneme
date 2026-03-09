extends Node


func _on_entity_is_dead() -> void:
	print("he died")
	get_parent().queue_free()
