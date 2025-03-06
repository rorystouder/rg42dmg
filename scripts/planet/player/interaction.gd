# res://scripts/planet/player/interaction.gd
extends Node

# Signal emitted when player enters a trading outpost, passing the shop inventory
signal open_trading_ui(shop_inventory: Inventory)

var player: CharacterBody3D = null
var trading_ui = null

# Sets up the interaction area for the player to detect outposts
func setup(body: CharacterBody3D, ui):
	player = body
	trading_ui = ui
	var area = Area3D.new()
	area.name = "InteractionArea"
	player.add_child(area)
	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	collision.shape.radius = 2.0
	area.add_child(collision)
	area.connect("area_entered", _on_area_entered)
	DebugLogger.log("Interaction area setup for player", "Interaction")

# Handles entering an outpost area, creating and populating a shop inventory
func _on_area_entered(area):
	if area.name == "InteractionArea" and area.get_parent().name == "TradingOutpost":
		var shop_inventory = Inventory.new()
		var fuel = load("res://items/supply_fuel.tres")
		var laser = load("res://items/weapon_laser.tres")
		var engine = load("res://items/upgrade_engine.tres")
		
		# Verify resources loaded successfully
		if fuel and laser and engine:
			shop_inventory.add_item(fuel)
			shop_inventory.add_item(laser)
			shop_inventory.add_item(engine)
			DebugLogger.log("Shop inventory created with " + str(shop_inventory.slots.size()) + " items", "Interaction")
		else:
			DebugLogger.error("Failed to load shop items: Fuel=" + str(fuel) + ", Laser=" + str(laser) + ", Engine=" + str(engine), "Interaction")
		
		player.add_child(shop_inventory)
		shop_inventory.owner = player
		emit_signal("open_trading_ui", shop_inventory)
		DebugLogger.log("Trading UI signal emitted", "Interaction")
	else:
		DebugLogger.warn("Entered area not recognized as TradingOutpost: " + area.get_parent().name, "Interaction")
