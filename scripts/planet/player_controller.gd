# res://scripts/planet/player_controller.gd
extends CharacterBody3D

# Player components
var movement = null
var interaction = null
var ship_upgrades = null

var trading_ui = null
var player_inventory = null
var credits: int = 1000

# Initializes player components and trading UI
func _ready():
	movement = preload("res://scripts/planet/player/movement.gd").new()
	add_child(movement)
	movement.setup(self)
	DebugLogger.log("Movement component initialized", "PlayerController")
	
	interaction = preload("res://scripts/planet/player/interaction.gd").new()
	add_child(interaction)
	interaction.setup(self, trading_ui)
	if not interaction.is_connected("open_trading_ui", _on_open_trading_ui):
		if interaction.connect("open_trading_ui", _on_open_trading_ui) == OK:
			DebugLogger.log("Connected open_trading_ui signal", "PlayerController")
		else:
			DebugLogger.error("Failed to connect open_trading_ui signal", "PlayerController")
	
	ship_upgrades = preload("res://scripts/planet/player/ship_upgrades.gd").new()
	add_child(ship_upgrades)
	ship_upgrades.setup(self)
	DebugLogger.log("Ship upgrades component initialized", "PlayerController")
	
	# Trading UI setup (currently partially disabled)
	player_inventory = get_node_or_null("../Inventory")
	if player_inventory:
		DebugLogger.log("Player inventory found with " + str(player_inventory.slots.size()) + " slots", "PlayerController")
	else:
		DebugLogger.error("Player inventory not found", "PlayerController")
	
	trading_ui = preload("res://scenes/trading/TradingUI.tscn").instantiate()
	trading_ui.visible = false
	get_viewport().call_deferred("add_child", trading_ui)
	call_deferred("initialize_trading_ui")

# Delegates physics processing to movement component
func _physics_process(delta):
	movement.process(delta)

# Initializes trading UI with player credits
func initialize_trading_ui():
	if trading_ui:
		trading_ui.set_player_credits(credits)
		DebugLogger.log("Trading UI initialized with credits: " + str(credits), "PlayerController")
	else:
		DebugLogger.error("Trading UI not instantiated", "PlayerController")

# Handles trading outpost entry signal from interaction.gd
func _on_open_trading_ui(shop_inventory: Inventory):
	DebugLogger.log("Trading outpost entered - Shop inventory slots: " + str(shop_inventory.slots.size()), "PlayerController")
	# Temporarily log shop inventory state until UI is fixed
	if player_inventory:
		# Disabled UI logic until TradingUI.tscn is corrected
		#trading_ui.set_inventories(player_inventory, shop_inventory)
		#trading_ui.set_player_credits(credits)
		#trading_ui.visible = true
		#get_tree().paused = true
		DebugLogger.log("Player inventory ready - Slots: " + str(player_inventory.slots.size()), "PlayerController")
	else:
		DebugLogger.error("Cannot open trading UI - Player inventory is null", "PlayerController")
