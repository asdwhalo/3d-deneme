extends CanvasLayer

@onready var player:Player = $/root/world/PlayerFps
#FIXME oyun durdurulunca fare gözükmüyor
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape"):
			if visible == true:
				player.is_cap = true
				visible = false
				await get_tree().physics_frame
				get_tree().paused = false
			else:
				player.is_cap = false
				visible = true
				await get_tree().physics_frame
				get_tree().paused = true

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	print("ayarlarda yok")
func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("")
	print("ana menü yok daha")
