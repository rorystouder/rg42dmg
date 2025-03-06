# res://scripts/planet/player/ship_upgrades.gd
extends Node

signal speed_upgraded(level: int)

var player: CharacterBody3D = null
var upgrades: Array = []
var max_speed_level: int = 3
var current_speed_level: int = 0

func setup(body: CharacterBody3D):
	player = body
	set_process_input(true)  # Ensure input processing

func _input(event):
	if event.is_action_pressed("upgrade"):
		apply_speed_upgrade()

func apply_speed_upgrade():
	if current_speed_level < max_speed_level:
		current_speed_level += 1
		upgrades.append({"type": "speed", "level": current_speed_level})
		print("Speed upgraded to level: ", current_speed_level)
		emit_signal("speed_upgraded", current_speed_level)
	else:
		print("Speed upgrade at max level: ", max_speed_level)

func get_speed_bonus() -> float:
	return current_speed_level * 1.0
