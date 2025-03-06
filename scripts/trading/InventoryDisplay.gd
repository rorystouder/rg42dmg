# res://scripts/trading/InventoryDisplay.gd
extends Node
class_name InventoryDisplay

# UI elements
var player_items_container: VBoxContainer = null
var shop_items_container: VBoxContainer = null
var currency_label: Label = null

# Inventory data
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0

# Button arrays
var player_item_buttons: Array[Button] = []
var shop_item_buttons: Array[Button] = []

# Managers
var button_manager: InvButtonManager = null
var inventory_ui_manager: InventoryUIManager = null
var currency_ui_manager: CurrencyUIManager = null

# Setup the InventoryDisplay with UI elements
func setup(player_container: VBoxContainer, shop_container: VBoxContainer, label: Label) -> void:
	if not player_container or not shop_container or not label:
		DebugLogger.error("Failed to setup InventoryDisplay - Missing UI elements", "InventoryDisplay")
		return

	player_items_container = player_container
	shop_items_container = shop_container
	currency_label = label

	# Initialize managers
	button_manager = load("res://scripts/trading/managers/InvButtonManager.gd").new()
	inventory_ui_manager = load("res://scripts/trading/managers/InventoryUIManager.gd").new()
	currency_ui_manager = load("res://scripts/trading/managers/CurrencyUIManager.gd").new()

	DebugLogger.log("Inventory display setup complete", "InventoryDisplay")
	update_ui()

# Set player and shop inventories
func set_inventories(player_inv: Inventory, shop_inv: Inventory) -> void:
	if not player_inv or not shop_inv:
		DebugLogger.error("Invalid inventories - Player: " + str(player_inv) + ", Shop: " + str(shop_inv), "InventoryDisplay")
		return

	player_inventory = player_inv
	shop_inventory = shop_inv
	DebugLogger.log("Inventories updated - Player slots: " + str(player_inv.slots.size()) + ", Shop slots: " + str(shop_inv.slots.size()), "InventoryDisplay")
	update_ui()

# Set player credits and update UI
func set_player_credits(player_credits: int) -> void:
	credits = player_credits
	DebugLogger.log("Credits updated to: " + str(credits), "InventoryDisplay")
	update_ui()

# Update the UI to reflect current inventories and credits
func update_ui() -> void:
	if not _validate_ui_elements():
		return

	button_manager.clear_buttons(player_item_buttons, player_items_container)
	button_manager.clear_buttons(shop_item_buttons, shop_items_container)

	player_item_buttons = inventory_ui_manager.populate_player_inventory(player_inventory, player_items_container, _on_player_item_pressed)
	shop_item_buttons = inventory_ui_manager.populate_shop_inventory(shop_inventory, shop_items_container, _on_shop_item_pressed)
	currency_ui_manager.update_currency_label(currency_label, credits)

# Validate UI elements
func _validate_ui_elements() -> bool:
	if not player_items_container or not shop_items_container or not currency_label:
		DebugLogger.error("UI elements missing - Player: " + str(player_items_container) + ", Shop: " + str(shop_items_container) + ", Label: " + str(currency_label), "InventoryDisplay")
		return false
	return true

# Handle player item button press
func _on_player_item_pressed(index: int) -> void:
	get_parent().get_node("TransactionHandler").select_player_item(index)
	DebugLogger.log("Player item button pressed - Index: " + str(index), "InventoryDisplay")

# Handle shop item button press
func _on_shop_item_pressed(index: int) -> void:
	get_parent().get_node("TransactionHandler").select_shop_item(index)
	DebugLogger.log("Shop item button pressed - Index: " + str(index), "InventoryDisplay")
