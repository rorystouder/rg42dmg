# res://scripts/trading/TransactionHandler.gd
extends Node
class_name TransactionHandler

var buy_button: Button = null
var sell_button: Button = null
var trading_ui = null
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var selected_player_item: int = -1
var selected_shop_item: int = -1

func setup(buy_btn: Button, sell_btn: Button, ui):
	buy_button = buy_btn
	sell_button = sell_btn
	trading_ui = ui

	if buy_button:
		if not buy_button.is_connected("pressed", _on_buy_pressed):
			if buy_button.connect("pressed", _on_buy_pressed) == OK:
				DebugLogger.log("Buy button connected - Visible: " + str(buy_button.visible) + " Disabled: " + str(buy_button.disabled), "TransactionHandler")
			else:
				DebugLogger.error("Failed to connect Buy button pressed signal", "TransactionHandler")
	else:
		DebugLogger.error("Buy button not found", "TransactionHandler")

	if sell_button:
		if not sell_button.is_connected("pressed", _on_sell_pressed):
			if sell_button.connect("pressed", _on_sell_pressed) == OK:
				DebugLogger.log("Sell button connected - Visible: " + str(sell_button.visible) + " Disabled: " + str(sell_button.disabled), "TransactionHandler")
			else:
				DebugLogger.error("Failed to connect Sell button pressed signal", "TransactionHandler")
	else:
		DebugLogger.error("Sell button not found", "TransactionHandler")

	if trading_ui:
		DebugLogger.log("Trading UI reference set", "TransactionHandler")
	else:
		DebugLogger.error("Trading UI reference not provided", "TransactionHandler")

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	if player_inv and shop_inv:
		DebugLogger.log("Inventories set - Player slots: " + str(player_inv.slots.size()) + ", Shop slots: " + str(shop_inv.slots.size()), "TransactionHandler")
	else:
		DebugLogger.error("Failed to set inventories - Player: " + str(player_inv) + ", Shop: " + str(shop_inv), "TransactionHandler")

func select_player_item(index: int):
	selected_player_item = index
	selected_shop_item = -1
	DebugLogger.log("Selected player item - Index: " + str(index), "TransactionHandler")

func select_shop_item(index: int):
	selected_shop_item = index
	selected_player_item = -1
	DebugLogger.log("Selected shop item - Index: " + str(index), "TransactionHandler")

func _on_buy_pressed() -> void:
	DebugLogger.log("Buy button pressed - Shop selection: " + str(selected_shop_item), "TransactionHandler")
	if not shop_inventory or selected_shop_item < 0 or selected_shop_item >= shop_inventory.slots.size():
		DebugLogger.warn("Buy failed - Invalid shop selection or inventory: " + str(selected_shop_item), "TransactionHandler")
		return

	var item = shop_inventory.slots[selected_shop_item]
	if trading_ui.player_controller.player_credits >= item.price:
		if player_inventory.add_item(item.duplicate()):  # Add a copy to player
			shop_inventory.remove_item(selected_shop_item)  # Remove from shop
			trading_ui.player_controller.player_credits -= item.price
			trading_ui.set_player_credits(trading_ui.player_controller.player_credits)  # Update UI
			selected_shop_item = -1
			DebugLogger.log("Bought item: " + item.name + " New credits: " + str(trading_ui.player_controller.player_credits), "TransactionHandler")
		else:
			DebugLogger.warn("Buy failed - Player inventory full", "TransactionHandler")
	else:
		DebugLogger.warn("Buy failed - Insufficient credits: " + str(trading_ui.player_controller.player_credits) + " Price: " + str(item.price), "TransactionHandler")

func _on_sell_pressed() -> void:
	DebugLogger.log("Sell button pressed - Player selection: " + str(selected_player_item), "TransactionHandler")
	if not player_inventory or selected_player_item < 0 or selected_player_item >= player_inventory.slots.size():
		DebugLogger.warn("Sell failed - Invalid player selection or inventory: " + str(selected_player_item), "TransactionHandler")
		return

	var item = player_inventory.slots[selected_player_item]
	if shop_inventory.add_item(item.duplicate()):  # Add a copy to shop
		player_inventory.remove_item(selected_player_item)  # Remove from player
		var sell_price = item.price / 2  # Half price for selling
		trading_ui.player_controller.player_credits += sell_price
		trading_ui.set_player_credits(trading_ui.player_controller.player_credits)  # Update UI
		selected_player_item = -1
		DebugLogger.log("Sold item: " + item.name + " New credits: " + str(trading_ui.player_controller.player_credits), "TransactionHandler")
	else:
		DebugLogger.warn("Sell failed - Shop inventory full", "TransactionHandler")
