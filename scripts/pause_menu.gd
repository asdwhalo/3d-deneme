extends CanvasLayer

@onready var player:Player = $/root/world/PlayerFps

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape"):
			if visible == true:
				player.is_cap = true
				visible = false
			else:
				player.is_cap = false
				visible = true

func _on_resume_pressed() -> void:
	visible = false

func _on_button_2_pressed() -> void:
	print("ayarlarda yok")
func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("")
	print("ana menü yok daha")
