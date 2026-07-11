class_name ParryableArea
extends Area3D

@onready var parent:Node3D = get_parent()
@onready var player: Player 

func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player")
	area_entered.connect(on_parry_area_entered)

func parry():
	print(str(player))
	if parent is Bullet:
		parent.damage *= 1.25
		parent.speed *= -2.0  if  parent.speed > 0.0 else 2.0
		parent.global_rotation = player.global_rotation


func on_parry_area_entered(area):
	if area.is_in_group("parry_area"):
		player = area.get_parent().get_parent().get_parent()
