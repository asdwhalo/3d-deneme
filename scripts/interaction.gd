extends Area3D
class_name interacableArea3D

# bu node nesnelerin etkileşim anında sinyal gndermesini sağlayacak?
signal on_interac

func _init() -> void:
	collision_mask = 3
	on_interac.connect(on_interaction)


func on_interaction():
	print(str(get_parent()) + "get interac request")
