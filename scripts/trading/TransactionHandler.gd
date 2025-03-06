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
			buy_button.connect("pressed", _on_buy_pressed)
		buy_button.visible = true
		buy_button.disabled = false
		DebugLogger.log("Buy button connected - Visible: " + str(buy_button.visible) + " Disabled: " + str(buy_button.disabled), "TransactionHandler")
	else:
		DebugLogger.error("Buy button not found", "TransactionHandler")
	if sell_button:
		if not sell_button.is_connected("pressed", _on_sell_pressed):
			sell_button.connect("pressed", _on_sell_pressed)
		sell_button.visible = true
		sell_button.disabled = false
		DebugLogger.log("Sell button connected - Visible: " + str(sell_button.visible) + " Disabled: " + str(sell_button.disabled), "TransactionHandler")
	else:
		DebugLogger.error("Sell button not found", "TransactionHandler")

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	DebugLogger.log("Inventories set - Player: " + str(player_inventory) + " Shop: " + str(shop_inventory), "TransactionHandler")

func select_player_item(index: int):
	selected_player_item = index
	selected_shop_item = -1
	DebugLogger.log("Selected player item: " + str(index), "TransactionHandler")

func select_shop_item(index: int):
	selected_shop_item = index
	selected_player_item = -1
	DebugLogger.log("Selected shop item: " + str(index), "TransactionHandler")

func _on_buy_pressed():
	DebugLogger.log("Buy button pressed - Selection: " + str(selected_shop_item), "TransactionHandler")
	if shop_inventory and selected_shop_item >= 0 and selected_shop_item < shop_inventory.slots.size():
		var index = selected_shop_item
		var item = shop_inventory.slots[index]
		if trading_ui.credits >= item.price and player_inventory.add_item(item):
			trading_ui.credits -= item.price
			shop_inventory.remove_item(index)
			selected_shop_item = -1
			trading_ui.inventory_display.update_ui()
			DebugLogger.log("Bought item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
		else:
			DebugLogger.warn("Buy failed - Credits: " + str(trading_ui.credits) + " Price: " + str(item.price), "TransactionHandler")
	else:
		DebugLogger.warn("Buy failed - Invalid shop selection: " + str(selected_shop_item), "TransactionHandler")

func _on_sell_pressed():
	DebugLogger.log("Sell button pressed - Selection: " + str(selected_player_item), "TransactionHandler")
	if player_inventory and selected_player_item >= 0 and selected_player_item < player_inventory.slots.size():
		var index = selected_player_item
		var item = player_inventory.slots[index]
		if shop_inventory.add_item(item):
			trading_ui.credits += item.price / 2
			player_inventory.remove_item(index)
			selected_player_item = -1
			trading_ui.inventory_display.update_ui()
			DebugLogger.log("Sold item: " + item.name + " New credits: " + str(trading_ui.credits), "TransactionHandler")
		else:
			DebugLogger.warn("Sell failed - Shop inventory full", "TransactionHandler")
	else:
		DebugLogger.warn("Sell failed - Invalid player selection: " + str(selected_player_item), "TransactionHandler")
