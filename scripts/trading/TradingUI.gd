# res://scripts/trading/TradingUI.gd
extends Control

var player_item_list = null
var shop_item_list = null
var currency_label = null
var buy_button = null
var sell_button = null

var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0

var inventory_display = null
var transaction_handler = null
var input_manager = null

func _ready():
	player_item_list = get_node_or_null("Panel/PlayerInventory/ItemList")
	shop_item_list = get_node_or_null("Panel/ShopInventory/ItemList")
	currency_label = get_node_or_null("Panel/CurrencyLabel")
	buy_button = get_node_or_null("Panel/BuyButton")
	sell_button = get_node_or_null("Panel/SellButton")

	inventory_display = InventoryDisplay.new()
	inventory_display.name = "InventoryDisplay"
	add_child(inventory_display)
	assert(inventory_display != null, "InventoryDisplay failed to initialize")
	inventory_display.setup(player_item_list, shop_item_list, currency_label)

	transaction_handler = TransactionHandler.new()
	transaction_handler.name = "TransactionHandler"
	add_child(transaction_handler)
	assert(transaction_handler != null, "TransactionHandler failed to initialize")
	transaction_handler.setup(buy_button, sell_button, self)

	input_manager = InputManager.new()
	input_manager.name = "InputManager"
	add_child(input_manager)
	assert(input_manager != null, "InputManager failed to initialize")
	input_manager.setup(self)

	if player_item_list:
		player_item_list.visible = true
	if shop_item_list:
		shop_item_list.visible = true

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	inventory_display.set_inventories(player_inv, shop_inv)
	transaction_handler.set_inventories(player_inv, shop_inv)

func set_player_credits(player_credits: int):
	credits = player_credits
	inventory_display.set_player_credits(credits)

func get_player_credits() -> int:
	return credits
