extends CharacterBody3D

@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var rotation_speed = 2.0

var speed = walk_speed
var trading_ui = null
var player_inventory = null
var credits: int = 1000

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
	player_inventory = get_node_or_null("../Inventory")
	print("Player inventory in _ready: ", player_inventory)
	if not player_inventory:
		print("Error: Player Inventory not found!")
	else:
		print("Player inventory slots in _ready: ", player_inventory.slots)
	# Delay setting credits until trading_ui is ready
	call_deferred("initialize_trading_ui")

func initialize_trading_ui():
	if trading_ui:
		trading_ui.set_player_credits(credits)
		print("Trading UI initialized with credits: ", credits)
	else:
		print("Error: trading_ui is null after deferred add")

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
		print("Adding items to shop inventory:")
		var fuel = load("res://items/supply_fuel.tres")
		var laser = load("res://items/weapon_laser.tres")
		var engine = load("res://items/upgrade_engine.tres")
		print("Fuel: ", fuel)
		print("Laser: ", laser)
		print("Engine: ", engine)
		shop_inventory.add_item(fuel)
		shop_inventory.add_item(laser)
		shop_inventory.add_item(engine)
		print("Shop inventory slots: ", shop_inventory.slots)
		add_child(shop_inventory)
		shop_inventory.owner = self
		if player_inventory:
			print("Setting inventories - Player slots: ", player_inventory.slots)
			trading_ui.set_inventories(player_inventory, shop_inventory)
			trading_ui.set_player_credits(credits)
			trading_ui.visible = true
			get_tree().paused = true
		else:
			print("Error: Cannot open trading UI - player inventory is null")
