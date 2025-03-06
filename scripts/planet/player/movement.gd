# res://scripts/planet/player/movement.gd
extends Node

var player: CharacterBody3D = null

# Exported variables for editor tweaking
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var rotation_speed = 2.0

var speed = walk_speed

# Sets up movement with the player body and connects to ship upgrades
func setup(body: CharacterBody3D):
	player = body
	var upgrades = player.get_node_or_null("ship_upgrades")
	if upgrades:
		if not upgrades.is_connected("speed_upgraded", _on_speed_upgraded):
			if upgrades.connect("speed_upgraded", _on_speed_upgraded) == OK:
				DebugLogger.log("Connected speed_upgraded signal from ship_upgrades", "Movement")
			else:
				DebugLogger.error("Failed to connect speed_upgraded signal", "Movement")
		else:
			DebugLogger.log("speed_upgraded signal already connected", "Movement")
	else:
		DebugLogger.warn("ship_upgrades node not found", "Movement")
	DebugLogger.log("Movement setup complete", "Movement")

# Processes player movement and physics each frame
func process(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_velocity
		DebugLogger.log("Jump triggered - Velocity Y: " + str(player.velocity.y), "Movement")
	
	# Determine base speed (sprint or walk)
	speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var ship_upgrades = player.get_node_or_null("ship_upgrades")
	if ship_upgrades:
		speed += ship_upgrades.get_speed_bonus()
	
	# Calculate movement direction
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_forward", "move_backward")
	).normalized()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
		DebugLogger.log("Moving - Direction: " + str(direction) + " Speed: " + str(speed), "Movement")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)
	
	# Handle rotation
	var rotation_input = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_input -= 1.0
	if rotation_input != 0.0:
		player.rotate_y(rotation_input * rotation_speed * delta)
		DebugLogger.log("Rotating - Input: " + str(rotation_input), "Movement")
	
	player.move_and_slide()

# Updates speed when an upgrade is applied
func _on_speed_upgraded(level: int):
	var new_speed = speed + level * 1.0
	DebugLogger.log("Speed upgraded - Level: " + str(level) + " New speed: " + str(new_speed), "Movement")
