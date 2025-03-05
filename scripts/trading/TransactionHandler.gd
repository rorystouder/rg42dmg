# res://scripts/trading/TransactionHandler.gd
extends Node
class_name TransactionHandler

var buy_button = null
var sell_button = null
var trading_ui = null
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var selected_player_item = -1
var selected_shop_item = -1

func setup(buy_btn, sell_btn, ui):
	buy_button = buy_btn
	sell_button = sell_btn
	trading_ui = ui

	# Debug: Check if buy_button is valid
	if buy_button:
		if not buy_button.is_connected("pressed", _on_buy_pressed):
			buy_button.connect("pressed", _on_buy_pressed)
		DebugLogger.log("Buy button connected: " + str(buy_button), "TransactionHandler")
		buy_button.visible = true  # Ensure clickable
		buy_button.disabled = false  # Ensure not disabled
		DebugLogger.log("Buy button visible: " + str(buy_button.visible) + " Disabled: " + str(buy_button.disabled), "TransactionHandler")
	else:
		DebugLogger.error("Buy button is null", "TransactionHandler")

	# Debug: Check if sell_button is valid
	if sell_button:
		if not sell_button.is_connected("pressed", _on_sell_pressed):
			sell_button.connect("pressed", _on_sell_pressed)
		DebugLogger.log("Sell button connected: " + str(sell_button), "TransactionHandler")
		sell_button.visible = true  # Ensure clickable
		sell_button.disabled = false  # Ensure not disabled
	else:
		DebugLogger.error("Sell button not found", "TransactionHandler")

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	DebugLogger.log("Inventories set - Player slots: " + str(player_inventory.slots.size()) + " Shop slots: " + str(shop_inventory.slots.size()), "TransactionHandler")
	DebugLogger.log("Player inventory: " + str(player_inv) + " Shop inventory: " + str(shop_inv), "TransactionHandler")

func select_player_item(index: int):
	selected_player_item = index
	selected_shop_item = -1
	DebugLogger.log("Selected player item: " + str(index), "TransactionHandler")

func select_shop_item(index: int):
	selected_shop_item = index
	selected_player_item = -1
	DebugLogger.log("Selected shop item: " + str(index), "TransactionHandler")

func _on_buy_pressed():
	DebugLogger.log("_on_buy_pressed triggered", "TransactionHandler")

	# Debug: Check if shop_inventory and selected_shop_item are valid
	if shop_inventory:
		DebugLogger.log("Shop inventory is valid", "TransactionHandler")
	else:
		DebugLogger.error("Shop inventory is null", "TransactionHandler")

	if selected_shop_item >= 0 and selected_shop_item < shop_inventory.slots.size():
		DebugLogger.log("Selected shop item index: " + str(selected_shop_item), "TransactionHandler")
		var index = selected_shop_item
		var item = shop_inventory.slots[index]

		# Debug: Check if player has enough credits
		DebugLogger.log("Credits: " + str(trading_ui.credits) + " Item price: " + str(item.price), "TransactionHandler")
		if trading_ui.credits >= item.price:
			DebugLogger.log("Player has enough credits", "TransactionHandler")

			# Debug: Check if item is added to player inventory
			if player_inventory.add_item(item):
				DebugLogger.log("Item added to player inventory: " + item.name, "TransactionHandler")
				trading_ui.credits -= item.price
				shop_inventory.remove_item(index)
				DebugLogger.log("Bought item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
				selected_shop_item = -1
				trading_ui.inventory_display.update_ui()
				DebugLogger.log("UI updated after purchase", "TransactionHandler")
			else:
				DebugLogger.warn("Failed to add item to player inventory", "TransactionHandler")
		else:
			DebugLogger.warn("Buy failed - Not enough credits", "TransactionHandler")
	else:
		DebugLogger.warn("Buy failed - Invalid shop selection: " + str(selected_shop_item), "TransactionHandler")

func _on_sell_pressed():
	DebugLogger.log("Sell button pressed", "TransactionHandler")
	DebugLogger.log("Player inventory: " + str(player_inventory) + " Selection: " + str(selected_player_item), "TransactionHandler")
	if player_inventory and selected_player_item >= 0 and selected_player_item < player_inventory.slots.size():
		var index = selected_player_item
		var item = player_inventory.slots[index]
		if shop_inventory.add_item(item):
			trading_ui.credits += item.price / 2
			player_inventory.remove_item(index)
			DebugLogger.log("Sold item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
			selected_player_item = -1
			trading_ui.inventory_display.update_ui()
		else:
			DebugLogger.warn("Sell failed - Shop inventory full", "TransactionHandler")
	else:
		DebugLogger.warn("Sell failed - Invalid player selection: " + str(selected_player_item), "TransactionHandler")
