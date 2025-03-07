# res://scripts/trading/TradingUI.gd
extends Control

var player_items_container: VBoxContainer = null
var shop_items_container: VBoxContainer = null
var currency_label: Label = null
var buy_button: Button = null
var sell_button: Button = null

var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0

var inventory_display: InventoryDisplay = null
var transaction_handler: TransactionHandler = null
var input_manager: InputManager = null

func _ready():
	player_items_container = get_node_or_null("Panel/PlayerInventory/Items")
	shop_items_container = get_node_or_null("Panel/ShopInventory/Items")
	currency_label = get_node_or_null("Panel/CurrencyLabel")
	buy_button = get_node_or_null("Panel/BuyButton")
	sell_button = get_node_or_null("Panel/SellButton")

	_log_ui_elements()
	_initialize_components()
	_set_ui_visibility()

func _log_ui_elements():
	if player_items_container:
		DebugLogger.log("Player Items Container found at Panel/PlayerInventory/Items", "TradingUI")
	else:
		DebugLogger.error("Player Items Container not found at Panel/PlayerInventory/Items - Check TradingUI.tscn", "TradingUI")
	if shop_items_container:
		DebugLogger.log("Shop Items Container found at Panel/ShopInventory/Items", "TradingUI")
	else:
		DebugLogger.error("Shop Items Container not found at Panel/ShopInventory/Items - Check TradingUI.tscn", "TradingUI")
	if currency_label:
		DebugLogger.log("Currency Label found at Panel/CurrencyLabel", "TradingUI")
	else:
		DebugLogger.error("Currency Label not found at Panel/CurrencyLabel", "TradingUI")
	if buy_button:
		DebugLogger.log("Buy Button found at Panel/BuyButton - Visible: " + str(buy_button.visible) + " Disabled: " + str(buy_button.disabled), "TradingUI")
	else:
		DebugLogger.error("Buy Button not found at Panel/BuyButton", "TradingUI")
	if sell_button:
		DebugLogger.log("Sell Button found at Panel/SellButton - Visible: " + str(sell_button.visible) + " Disabled: " + str(sell_button.disabled), "TradingUI")
	else:
		DebugLogger.error("Sell Button not found at Panel/SellButton", "TradingUI")

func _initialize_components():
	inventory_display = InventoryDisplay.new()
	inventory_display.name = "InventoryDisplay"
	add_child(inventory_display)
	inventory_display.setup(player_items_container, shop_items_container, currency_label)
	DebugLogger.log("InventoryDisplay component initialized", "TradingUI")

	transaction_handler = TransactionHandler.new()
	transaction_handler.name = "TransactionHandler"
	add_child(transaction_handler)
	transaction_handler.setup(buy_button, sell_button, self)
	DebugLogger.log("TransactionHandler component initialized", "TradingUI")

	input_manager = InputManager.new()
	input_manager.name = "InputManager"
	add_child(input_manager)
	input_manager.setup(self)
	DebugLogger.log("InputManager component initialized", "TradingUI")

func _set_ui_visibility():
	if player_items_container:
		player_items_container.visible = true
	else:
		DebugLogger.warn("Player Items Container null - Skipping visibility toggle", "TradingUI")
	if shop_items_container:
		shop_items_container.visible = true
	else:
		DebugLogger.warn("Shop Items Container null - Skipping visibility toggle", "TradingUI")

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	if player_inv and shop_inv:
		player_inventory = player_inv
		shop_inventory = shop_inv
		inventory_display.set_inventories(player_inv, shop_inv)
		transaction_handler.set_inventories(player_inv, shop_inv)
		DebugLogger.log("Inventories set - Player slots: " + str(player_inv.slots.size()) + ", Shop slots: " + str(shop_inv.slots.size()), "TradingUI")
	else:
		DebugLogger.error("Invalid inventories - Player: " + str(player_inv) + ", Shop: " + str(shop_inv), "TradingUI")

func set_player_credits(player_credits: int):
	credits = player_credits
	inventory_display.set_player_credits(credits)
	DebugLogger.log("Player credits updated to: " + str(credits), "TradingUI")

func get_player_credits() -> int:
	return credits
