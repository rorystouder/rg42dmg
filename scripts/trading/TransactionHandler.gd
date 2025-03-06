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
var player_item_list: VBoxContainer = null  # For player inventory UI
var shop_item_list: VBoxContainer = null    # For shop inventory UI
var selected_player_item: int = -1
var selected_shop_item: int = -1

# Setup the TransactionHandler with buttons and UI
func setup(buy_btn: Button, sell_btn: Button, ui, player_list: VBoxContainer, shop_list: VBoxContainer):
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
func _on_buy_pressed() -> void:
	DebugLogger.log("Buy button pressed", "TransactionHandler")
	if shop_item_list:
		var selected = shop_item_list.get_selected_items()
		if selected.size() > 0:
			var index = selected[0]
			DebugLogger.log("Selected shop item index: " + str(index), "TransactionHandler")
			# Rest of the buy logic...
		else:
			DebugLogger.warn("No item selected to buy", "TransactionHandler")
	else:
		DebugLogger.error("Shop ItemList not found", "TransactionHandler")

func _on_sell_pressed() -> void:
	DebugLogger.log("Sell button pressed", "TransactionHandler")
	if player_item_list:
		var selected = player_item_list.get_selected_items()
		if selected.size() > 0:
			var index = selected[0]
			DebugLogger.log("Selected player item index: " + str(index), "TransactionHandler")
			# Rest of the sell logic...
		else:
			DebugLogger.warn("No item selected to sell", "TransactionHandler")
	else:
		DebugLogger.error("Player ItemList not found", "TransactionHandler")
