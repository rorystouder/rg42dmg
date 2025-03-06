# res://scripts/trading/TransactionHandler.gd
extends Node
class_name TransactionHandler

# UI elements
var buy_button: Button = null
var sell_button: Button = null
var trading_ui = null

# Inventories
var player_inventory: Inventory = null
var shop_inventory: Inventory = null

# Item selection
var player_item_list: ItemList = null  # For player inventory UI
var shop_item_list: ItemList = null    # For shop inventory UI
var selected_player_item: int = -1
var selected_shop_item: int = -1

# Setup the TransactionHandler with buttons and UI
func setup(buy_btn: Button, sell_btn: Button, ui, player_list: ItemList, shop_list: ItemList):
	buy_button = buy_btn
	sell_button = sell_btn
	trading_ui = ui
	player_item_list = player_list
	shop_item_list = shop_list

	# Connect item selection signals
	if player_item_list:
		player_item_list.connect("item_selected", select_player_item)
		DebugLogger.log("Player ItemList connected for selection", "TransactionHandler")
	else:
		DebugLogger.error("Player ItemList not found", "TransactionHandler")

	if shop_item_list:
		shop_item_list.connect("item_selected", select_shop_item)
		DebugLogger.log("Shop ItemList connected for selection", "TransactionHandler")
	else:
		DebugLogger.error("Shop ItemList not found", "TransactionHandler")

	# Connect buy and sell buttons
	if buy_button:
		if buy_button.connect("pressed", _on_buy_pressed) == OK:
			DebugLogger.log("Buy button connected - Visible: true Disabled: false", "TransactionHandler")
		else:
			DebugLogger.error("Failed to connect Buy button pressed signal", "TransactionHandler")
		buy_button.visible = true
		buy_button.disabled = false
	else:
		DebugLogger.error("Buy button not found", "TransactionHandler")

	if sell_button:
		if sell_button.connect("pressed", _on_sell_pressed) == OK:
			DebugLogger.log("Sell button connected - Visible: true Disabled: false", "TransactionHandler")
		else:
			DebugLogger.error("Failed to connect Sell button pressed signal", "TransactionHandler")
		sell_button.visible = true
		sell_button.disabled = false
	else:
		DebugLogger.error("Sell button not found", "TransactionHandler")

# Set player and shop inventories
func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	DebugLogger.log("Inventories set - Player: " + str(player_inventory) + " Shop: " + str(shop_inventory), "TransactionHandler")

# Handle player item selection
func select_player_item(index: int):
	selected_player_item = index
	selected_shop_item = -1
	DebugLogger.log("Selected player item: " + str(index), "TransactionHandler")

# Handle shop item selection
func select_shop_item(index: int):
	selected_shop_item = index
	selected_player_item = -1
	DebugLogger.log("Selected shop item: " + str(index), "TransactionHandler")

# Handle buy button press
func _on_buy_pressed():
	DebugLogger.log("Buy button pressed - Shop selection: " + str(selected_shop_item), "TransactionHandler")
	if shop_inventory and selected_shop_item >= 0 and selected_shop_item < shop_inventory.slots.size():
		var index = selected_shop_item
		var item = shop_inventory.slots[index]
		if trading_ui.credits >= item.price:
			if player_inventory.add_item(item):
				# Update credits and inventory
				trading_ui.credits -= item.price
				shop_inventory.remove_item(index)
				selected_shop_item = -1

				# Update UI
				shop_item_list.remove_item(index)
				shop_item_list.unselect_all()
				trading_ui.inventory_display.update_ui()

				DebugLogger.log("Bought item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
			else:
				DebugLogger.warn("Failed to add item to player inventory", "TransactionHandler")
		else:
			DebugLogger.warn("Buy failed - Not enough credits: " + str(trading_ui.credits) + " Price: " + str(item.price), "TransactionHandler")
	else:
		DebugLogger.warn("Buy failed - Invalid shop selection: " + str(selected_shop_item) + " or shop_inventory: " + str(shop_inventory), "TransactionHandler")

# Handle sell button press
func _on_sell_pressed():
	DebugLogger.log("Sell button pressed - Player selection: " + str(selected_player_item), "TransactionHandler")
	if player_inventory and selected_player_item >= 0 and selected_player_item < player_inventory.slots.size():
		var index = selected_player_item
		var item = player_inventory.slots[index]
		if shop_inventory.add_item(item):
			# Update credits and inventory
			trading_ui.credits += item.price / 2
			player_inventory.remove_item(index)
			selected_player_item = -1

			# Update UI
			player_item_list.remove_item(index)
			player_item_list.unselect_all()
			trading_ui.inventory_display.update_ui()

			DebugLogger.log("Sold item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
		else:
			DebugLogger.warn("Sell failed - Shop inventory full", "TransactionHandler")
	else:
		DebugLogger.warn("Sell failed - Invalid player selection: " + str(selected_player_item) + " or player_inventory: " + str(player_inventory), "TransactionHandler")
