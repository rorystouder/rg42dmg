# res://scripts/planet/player/ship_upgrades.gd
extends Node

# Signal emitted when speed is upgraded, passing the new level
signal speed_upgraded(level: int)

var player: CharacterBody3D = null
var upgrades: Array = []  # Stores upgrade data (type and level)
var max_speed_level: int = 3  # Maximum speed upgrade level
var current_speed_level: int = 0  # Current speed upgrade level

# Initializes the ship upgrades system for the player
func setup(body: CharacterBody3D):
	player = body
	set_process_input(true)  # Enable input processing for upgrades
	DebugLogger.log("Ship upgrades initialized for player", "ShipUpgrades")

# Handles input events to trigger upgrades
func _input(event):
	if event.is_action_pressed("upgrade"):
		apply_speed_upgrade()
		DebugLogger.log("Upgrade action triggered", "ShipUpgrades")

# Applies a speed upgrade if not at max level
func apply_speed_upgrade():
	if current_speed_level < max_speed_level:
		current_speed_level += 1
		var upgrade_data = {"type": "speed", "level": current_speed_level}
		upgrades.append(upgrade_data)
		DebugLogger.log("Speed upgraded - Level: " + str(current_speed_level) + " Total upgrades: " + str(upgrades.size()), "ShipUpgrades")
		emit_signal("speed_upgraded", current_speed_level)
	else:
		DebugLogger.warn("Speed upgrade attempt failed - Already at max level: " + str(max_speed_level), "ShipUpgrades")

# Returns the current speed bonus based on upgrade level
func get_speed_bonus() -> float:
	return current_speed_level * 1.0  # 1.0 speed boost per level
