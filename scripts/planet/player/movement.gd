# res://scripts/planet/player/movement.gd
extends Node

var player: CharacterBody3D = null

@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var rotation_speed = 2.0

var speed = walk_speed

func setup(body: CharacterBody3D):
	player = body
	# Connect to ship_upgrades for speed updates
	var upgrades = player.get_node_or_null("ship_upgrades")
	if upgrades:
		upgrades.connect("speed_upgraded", _on_speed_upgraded)

func process(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_velocity
	speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var ship_upgrades = player.get_node_or_null("ship_upgrades")
	if ship_upgrades:
		speed += ship_upgrades.get_speed_bonus()  # Apply upgrade bonus
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_forward", "move_backward")
	).normalized()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)
	var rotation_input = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_input -= 1.0
	player.rotate_y(rotation_input * rotation_speed * delta)
	player.move_and_slide()

func _on_speed_upgraded(level: int):
	print("Movement updated - Speed level: ", level, " New speed: ", speed + level * 1.0)
