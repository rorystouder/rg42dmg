# res://scripts/planet/player_controller.gd
extends CharacterBody3D

# Player components
var movement = null
var interaction = null
var ship_upgrades = null

var trading_ui = null
var player_inventory = null
var credits: int = 1000

func _ready():
	# Initialize movement component
	movement = preload("res://scripts/planet/player/movement.gd").new()
	add_child(movement)
	movement.setup(self)  # Pass CharacterBody3D to movement
	
	# Initialize interaction component
	interaction = preload("res://scripts/planet/player/interaction.gd").new()
	add_child(interaction)
	interaction.setup(self, trading_ui)  # Pass self and trading_ui for outpost detection
	
	# Initialize ship upgrades component
	ship_upgrades = preload("res://scripts/planet/player/ship_upgrades.gd").new()
	add_child(ship_upgrades)
	ship_upgrades.setup(self)  # Pass self for upgrade application
	
	# Setup trading UI
	trading_ui = preload("res://scenes/trading/TradingUI.tscn").instantiate()
	trading_ui.visible = false
	get_viewport().call_deferred("add_child", trading_ui)
	
	# Setup inventory
	player_inventory = get_node_or_null("../Inventory")
	print("Player inventory in _ready: ", player_inventory)
	if not player_inventory:
		print("Error: Player Inventory not found!")
	
	# Connect to interaction for trading UI trigger
	interaction.connect("open_trading_ui", _on_open_trading_ui)
	call_deferred("initialize_trading_ui")

func _physics_process(delta):
	# Delegate physics processing to movement script
	movement.process(delta)  # Handles movement and upgrades

func initialize_trading_ui():
	if trading_ui:
		trading_ui.set_player_credits(credits)
		print("Trading UI initialized with credits: ", credits)

# Signal handler from interaction.gd
func _on_open_trading_ui(shop_inventory: Inventory):
	if player_inventory:
		print("Setting inventories - Player slots: ", player_inventory.slots)
		trading_ui.set_inventories(player_inventory, shop_inventory)
		trading_ui.set_player_credits(credits)
		trading_ui.visible = true
		get_tree().paused = true
	else:
		print("Error: Cannot open trading UI - player inventory is null")
