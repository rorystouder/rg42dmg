extends CharacterBody3D

@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var rotation_speed = 2.0

var speed = walk_speed
var trading_ui = null
var player_inventory = null  # Add reference to track inventory
var credits: int = 1000  # Player's credits

func _ready():
	var area = Area3D.new()
	area.name = "InteractionArea"
	add_child(area)
	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	collision.shape.radius = 2.0
	area.add_child(collision)
	area.connect("area_entered", _on_area_entered)
	trading_ui = preload("res://scenes/TradingUI.tscn").instantiate()
	trading_ui.visible = false
	get_viewport().call_deferred("add_child", trading_ui)
	player_inventory = get_node_or_null("../Inventory")  # Safely get inventory
	if not player_inventory:
		print("Error: Player Inventory not found!")

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
	var rotation_input = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_input -= 1.0
	rotate_y(rotation_input * rotation_speed * delta)
	move_and_slide()

func _on_area_entered(area):
	if area.name == "InteractionArea" and area.get_parent().name == "TradingOutpost":
		var shop_inventory = Inventory.new()
		shop_inventory.add_item(load("res://items/supply_fuel.tres"))
		shop_inventory.add_item(load("res://items/weapon_laser.tres"))
		shop_inventory.add_item(load("res://items/upgrade_engine.tres"))
		add_child(shop_inventory)
		shop_inventory.owner = self
		if player_inventory:
			trading_ui.set_inventories(player_inventory, shop_inventory)
			trading_ui.set_player_credits(credits)  # Sync credits
			trading_ui.visible = true
			get_tree().paused = true
		else:
			print("Error: Cannot open trading UI - player inventory is null")

func _input(event):
	if event.is_action_pressed("ui_cancel") and trading_ui.visible:
		credits = trading_ui.get_player_credits()  # Update player credits after trading
		trading_ui.visible = false
		get_tree().paused = false
