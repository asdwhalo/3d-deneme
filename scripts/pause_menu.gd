extends CanvasLayer

@onready var world := get_tree().current_scene
@export var player:Player
#@onready var _player = $/root/world/PlayerFps

#FIXME oyun durdurulunca fare gözükmüyor
func _ready() -> void:
	world = get_tree().current_scene
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape"):
			if visible == true:
				
				visible = false
				get_tree().paused = false
				player.is_cap = true
			else:
				visible = true
				get_tree().paused = true
				player.is_cap = false

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	print("ayarlarda yok")
func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("")
	print("ana menü yok daha")
