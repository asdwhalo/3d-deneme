extends Control

@onready var info: Label = $info
@onready var speed: Label = $playerInfo/speed
@onready var is_ground: Label = $playerInfo/groundCheck
@onready var inventory: Label = $inventory
@onready var hp_label: Label = $hpLabel
@onready var current_weapon: Label = $playerInfo/currentWeapon
@onready var iframeleft_time: Label = $playerInfo/iframeleftTime

@export var player:Player
@export var gun_manager:GunManager

func _process(_delta: float) -> void:
	hp_label.text = str(player.hp) + "/" + str(player.max_hp - player.hard_damage)
	current_weapon.text = str(gun_manager.current_weapon_id)
	iframeleft_time.text = str(player.iframe_timer.time_left)
