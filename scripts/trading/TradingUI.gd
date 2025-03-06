# res://scripts/trading/TradingUI.gd
extends Control

var player_items_container = null
var shop_items_container = null
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
	player_items_container = get_node_or_null("Panel/PlayerInventory/Items")
	shop_items_container = get_node_or_null("Panel/ShopInventory/Items")
	currency_label = get_node_or_null("Panel/CurrencyLabel")
	buy_button = get_node_or_null("Panel/BuyButton")
	sell_button = get_node_or_null("Panel/SellButton")
	print("Player Items Container: ", player_items_container)
	print("Shop Items Container: ", shop_items_container)
	print("Currency Label: ", currency_label)
	print("Buy Button: ", buy_button)
	print("Sell Button: ", sell_button)

	inventory_display = InventoryDisplay.new()
	inventory_display.name = "InventoryDisplay"
	add_child(inventory_display)
	inventory_display.setup(player_items_container, shop_items_container, currency_label)

	transaction_handler = TransactionHandler.new()
	transaction_handler.name = "TransactionHandler"
	add_child(transaction_handler)
	transaction_handler.setup(buy_button, sell_button, self)

	input_manager = InputManager.new()
	input_manager.name = "InputManager"
	add_child(input_manager)
	input_manager.setup(self)

	if player_items_container:
		player_items_container.visible = true
	if shop_items_container:
		shop_items_container.visible = true

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
