# res://scripts/planet/spaceship.gd
extends CharacterBody3D

# Exported variables for easy tweaking in the editor
@export var speed = 10.0
@export var rotation_speed = 1.0

# Called every physics frame to handle spaceship movement and rotation
func _physics_process(delta):
	var input_dir = Vector3.ZERO
	
	# Movement inputs (relative to spaceship orientation)
	if Input.is_action_pressed("move_forward"):
		input_dir -= transform.basis.z  # Forward
	if Input.is_action_pressed("move_backward"):
		input_dir += transform.basis.z  # Backward
	if Input.is_action_pressed("move_left"):
		input_dir -= transform.basis.x  # Left
	if Input.is_action_pressed("move_right"):
		input_dir += transform.basis.x  # Right
	if Input.is_action_pressed("move_up"):
		input_dir += transform.basis.y  # Up
	if Input.is_action_pressed("move_down"):
		input_dir -= transform.basis.y  # Down
	
	# Normalize to prevent faster diagonal movement
	input_dir = input_dir.normalized()
	
	# Apply velocity and move
	velocity = input_dir * speed
	move_and_slide()
	
	# Log movement for debugging
	if input_dir != Vector3.ZERO:
		DebugLogger.log("Spaceship moving - Direction: " + str(input_dir) + " Speed: " + str(speed), "Spaceship")
	
	# Rotation inputs
	var rotation_input = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_input -= 1.0
	
	# Rotate around the Y-axis (yaw)
	if rotation_input != 0.0:
		rotate_y(rotation_input * rotation_speed * delta)
		DebugLogger.log("Spaceship rotating - Input: " + str(rotation_input), "Spaceship")

# Called when the spaceship enters an area (e.g., planet landing zone)
func _on_area_entered(area):
	if area.is_in_group("planet_landing_zone"):
		# Switch to planet scene
		var error = get_tree().change_scene_to_file("res://scenes/planets/PlanetScene.tscn")
		if error == OK:
			DebugLogger.log("Landed on planet - Scene changed to PlanetScene.tscn", "Spaceship")
		else:
			DebugLogger.error("Failed to change scene to PlanetScene.tscn - Error: " + str(error), "Spaceship")
	else:
		DebugLogger.warn("Entered unknown area: " + area.name, "Spaceship")
