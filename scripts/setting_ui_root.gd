extends Control


@onready var audio_settings_root: Control = %audioSettingsRoot
@onready var graphics_settings_root: Control = %graphicsSettingsRoot
@onready var tab_bar: TabBar = %TabBar
@onready var default_bus : AudioBusLayout = preload("res://default_bus_layout.tres")
@onready var spin_box: SpinBox = %SpinBox
@onready var option_button: OptionButton = %OptionButton

var aspect_ratio :Array[Vector2] = [Vector2(1920,1080),Vector2(100,50)]
var settings: SettingsResource = preload("res://resources/main_settings.tres")
var current_tab:int = 0

func _ready() -> void:
	ResourceLoader.load("res://resources/main_settings.tres")
	AudioServer.set_bus_volume_db(0,settings.main_sound_mult)
	spin_box.value = AudioServer.get_bus_volume_db(0)
	option_button.selected = settings.selected_aspect_ratio_id
	ProjectSettings.set_setting("display/window/size/viewport_height",settings.aspect_ratio.x)
	ProjectSettings.set_setting("display/window/size/viewport_width",settings.aspect_ratio.y)
	

func _on_exit_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://main_scene.tscn")
	ResourceSaver.save(settings,"res://resources/main_settings.tres")


func _on_tab_bar_tab_changed(tab: int) -> void:
	print(str(tab))
	current_tab = tab

func _process(_delta: float) -> void:
	if current_tab == 0:
		graphics_settings_root.set_process(false)
		audio_settings_root.visible = true
		graphics_settings_root.visible = false
	else:
		audio_settings_root.set_process(false)
		audio_settings_root.visible = false
		graphics_settings_root.visible = true


func _on_spin_box_value_changed(value: float) -> void:
	settings.main_sound_mult = value
	AudioServer.set_bus_volume_db(0,value)


func _on_option_button_item_selected(index: int) -> void:
	settings.aspect_ratio = aspect_ratio[index]
	settings.selected_aspect_ratio_id = index
	ProjectSettings.set_setting("display/window/size/viewport_height",aspect_ratio[index].y)
	ProjectSettings.set_setting("display/window/size/viewport_width",aspect_ratio[index].x)
	print(str(ProjectSettings.get_setting("display/window/size/viewport_width")))
