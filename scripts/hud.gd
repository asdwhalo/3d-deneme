extends Control

@onready var info: Label = $info
@onready var speed: Label = $playerInfo/speed
@onready var is_ground: Label = $playerInfo/groundCheck
@onready var inventory: Label = $inventory
@onready var hp_label: Label = $hpLabel

@export var player:Player

func _process(_delta: float) -> void:
	hp_label.text = str(player.hp) + "/" + str(player.max_hp - player.hard_damage)
	
