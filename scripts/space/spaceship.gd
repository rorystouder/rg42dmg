extends CharacterBody3D

@export var speed = 10.0
@export var rotation_speed = 1.0

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
	
	# Apply velocity
	velocity = input_dir * speed
	move_and_slide()
	
	# Rotation inputs
	var rotation_input = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_input -= 1.0
	
	# Rotate around the Y-axis (yaw)
	rotate_y(rotation_input * rotation_speed * delta)
	
	func _on_area_entered(area):
		if area.is_in_group("planet_landing_zone"):
		# Switch to planet scene
			get_tree().change_scene_to_file("res://scenes/planets/PlanetScene.tscn")
