extends CharacterBody3D

@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var gravity = 9.8

var speed = walk_speed

func _ready():
	var mission_manager = get_node("../MissionManager")  # Relative to Player
	print("MissionManager init at: ", get_path())
	if mission_manager:
		mission_manager.connect("mission_updated", _on_mission_updated)
	else:
		print("Error: MissionManager not found!")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_forward", "move_backward")
	).normalized()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	
	# Check mission objective
	var mission_manager = get_node("../MissionManager")
	if mission_manager and mission_manager.active_mission and not mission_manager.active_mission.completed:
		var target = Vector3(20, 0, 20) if mission_manager.active_mission.type == "delivery" else Vector3(15, 0, 15)
		if global_transform.origin.distance_to(target) < 2.0:
			mission_manager.complete_mission()

func _on_mission_updated(mission):
	if mission:
		print("New mission: ", mission.description)
	else:
		print("No more missions!")
