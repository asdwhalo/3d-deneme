extends CanvasLayer

@export var player:PlayerEntity



#@onready var _player = $/root/world/PlayerFps
var is_open:bool = false
#FIXME oyun durdurulunca fare gözükmüyor
func _ready() -> void:
	pass
	#world = get_tree().current_scene
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape"):
			if visible == true:
				
				visible = false
				get_tree().paused = false
				is_open = false
			else:
				visible = true
				get_tree().paused = true
				is_open = true

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	print("ayarlarda yok")
func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("")
	print("ana menü yok daha")
