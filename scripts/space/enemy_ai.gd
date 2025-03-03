extends CharacterBody3D

@export var speed = 8.0
@export var bullet_scene = preload("res://scenes/space/Bullet.tscn")
@export var fire_rate = 1.0  # Shots per second
var player = null
var time_since_last_shot = 0.0

func _ready():
	player = get_node_or_null("/root/Main/GameScenePlaceholder/SpaceScene/Spaceship")
	if not player:
		print("Error: Player spaceship not found!")

func _physics_process(delta):
	if player and is_instance_valid(player):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()
		look_at(player.global_transform.origin, Vector3.UP)
		
		# Firing logic
		time_since_last_shot += delta
		if time_since_last_shot >= 1.0 / fire_rate:
			fire()
			time_since_last_shot = 0.0

func fire():
	var bullet = bullet_scene.instantiate()
	# Add bullet to the scene root (not the enemy, to avoid inheriting movement)
	get_tree().root.add_child(bullet)
	# Position bullet at enemy’s front
	bullet.global_transform = global_transform
	bullet.global_transform.origin -= transform.basis.z * 1.5  # Offset from enemy
	# Apply impulse forward
	bullet.apply_impulse(-transform.basis.z * 20.0)  # Bullet speed
