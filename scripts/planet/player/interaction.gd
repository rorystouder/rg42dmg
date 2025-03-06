# res://scripts/planet/player/interaction.gd
extends Node

signal open_trading_ui(shop_inventory: Inventory)

var player: CharacterBody3D = null
var trading_ui = null

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
		player.add_child(shop_inventory)
		shop_inventory.owner = player
		emit_signal("open_trading_ui", shop_inventory)
