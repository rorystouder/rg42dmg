# res://scripts/trading/InventoryDisplay.gd
extends Node
class_name InventoryDisplay

var player_items_container: VBoxContainer = null
var shop_items_container: VBoxContainer = null
var currency_label: Label = null
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0
var player_item_buttons: Array = []
var shop_item_buttons: Array = []

# Setup the InventoryDisplay with UI elements
func setup(player_container: VBoxContainer, shop_container: VBoxContainer, label: Label):
	if player_container and shop_container and label:
		player_items_container = player_container
		shop_items_container = shop_container
		currency_label = label
		DebugLogger.log("Inventory display setup complete", "InventoryDisplay")
		update_ui()
	else:
		DebugLogger.error("Failed to setup InventoryDisplay - Missing UI elements", "InventoryDisplay")

# Set player and shop inventories
func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	if player_inv and shop_inv:
		player_inventory = player_inv
		shop_inventory = shop_inv
		DebugLogger.log("Inventories updated - Player slots: " + str(player_inv.slots.size()) + ", Shop slots: " + str(shop_inv.slots.size()), "InventoryDisplay")
		update_ui()
	else:
		DebugLogger.error("Invalid inventories - Player: " + str(player_inv) + ", Shop: " + str(shop_inv), "InventoryDisplay")

# Set player credits and update UI
func set_player_credits(player_credits: int):
	credits = player_credits
	DebugLogger.log("Credits updated to: " + str(credits), "InventoryDisplay")
	update_ui()

# Update the UI to reflect current inventories and credits
func update_ui():
	if not player_items_container or not shop_items_container or not currency_label:
		DebugLogger.error("UI elements missing - Player: " + str(player_items_container) + ", Shop: " + str(shop_items_container) + ", Label: " + str(currency_label), "InventoryDisplay")
		return

	# Clear existing buttons
	_clear_buttons(player_item_buttons, player_items_container)
	_clear_buttons(shop_item_buttons, shop_items_container)

	# Populate player inventory buttons
	if player_inventory and player_inventory.slots:
		for i in player_inventory.slots.size():
			var item = player_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ")"
			button.connect("pressed", _on_player_item_pressed.bind(i))
			player_items_container.add_child(button)
			player_item_buttons.append(button)
			DebugLogger.log("Added player item button: " + item.name, "InventoryDisplay")

	# Populate shop inventory buttons
	if shop_inventory and shop_inventory.slots:
		for i in shop_inventory.slots.size():
			var item = shop_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ") - " + str(item.price) + "c"
			button.connect("pressed", _on_shop_item_pressed.bind(i))
			shop_items_container.add_child(button)
			shop_item_buttons.append(button)
			DebugLogger.log("Added shop item button: " + item.name, "InventoryDisplay")

	# Update currency label
	if currency_label:
		currency_label.text = "Credits: " + str(credits)

# Clear buttons from a container
func _clear_buttons(buttons: Array, container: VBoxContainer):
	for button in buttons:
		button.queue_free()
	buttons.clear()

# Handle player item button press
func _on_player_item_pressed(index: int):
	get_parent().get_node("TransactionHandler").select_player_item(index)
	DebugLogger.log("Player item button pressed - Index: " + str(index), "InventoryDisplay")

# Handle shop item button press
func _on_shop_item_pressed(index: int):
	get_parent().get_node("TransactionHandler").select_shop_item(index)
	DebugLogger.log("Shop item button pressed - Index: " + str(index), "InventoryDisplay")
