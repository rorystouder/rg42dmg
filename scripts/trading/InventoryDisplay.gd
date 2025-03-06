# res://scripts/trading/InventoryDisplay.gd
extends Node
class_name InventoryDisplay

# UI elements for displaying inventories
var player_items_container: VBoxContainer = null
var shop_items_container: VBoxContainer = null
var currency_label: Label = null

# Inventory and credits data
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0

# Arrays to track item buttons
var player_item_buttons: Array = []
var shop_item_buttons: Array = []

# Sets up the UI elements for inventory display
func setup(player_container: VBoxContainer, shop_container: VBoxContainer, label: Label):
	player_items_container = player_container
	shop_items_container = shop_container
	currency_label = label
	update_ui()
	DebugLogger.log("Inventory display setup complete", "InventoryDisplay")

# Updates the displayed inventories
func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	update_ui()
	if player_inv and shop_inv:
		DebugLogger.log("Inventories updated - Player slots: " + str(player_inv.slots.size()) + ", Shop slots: " + str(shop_inv.slots.size()), "InventoryDisplay")
	else:
		DebugLogger.error("Invalid inventories - Player: " + str(player_inv) + ", Shop: " + str(shop_inv), "InventoryDisplay")

# Updates the displayed credits
func set_player_credits(player_credits: int):
	credits = player_credits
	update_ui()
	DebugLogger.log("Credits updated to: " + str(credits), "InventoryDisplay")

# Refreshes the UI with current inventory and credits
func update_ui():
	if not player_items_container or not shop_items_container or not currency_label:
		DebugLogger.error("UI elements missing - Player: " + str(player_items_container) + ", Shop: " + str(shop_items_container) + ", Label: " + str(currency_label), "InventoryDisplay")
		return
	
	# Clear existing buttons
	for button in player_item_buttons:
		button.queue_free()
	player_item_buttons.clear()
	for button in shop_item_buttons:
		button.queue_free()
	shop_item_buttons.clear()
	
	# Populate player inventory buttons
	if player_inventory and player_inventory.slots:
		for i in player_inventory.slots.size():
			var item = player_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ")"
			if button.connect("pressed", func(): get_parent().get_node("TransactionHandler").select_player_item(i)) == OK:
				player_items_container.add_child(button)
				player_item_buttons.append(button)
				DebugLogger.log("Added player item button: " + item.name, "InventoryDisplay")
			else:
				DebugLogger.error("Failed to connect pressed signal for player item: " + item.name, "InventoryDisplay")
	
	# Populate shop inventory buttons
	if shop_inventory and shop_inventory.slots:
		for i in shop_inventory.slots.size():
			var item = shop_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ") - " + str(item.price) + "c"
			if button.connect("pressed", func(): get_parent().get_node("TransactionHandler").select_shop_item(i)) == OK:
				shop_items_container.add_child(button)
				shop_item_buttons.append(button)
				DebugLogger.log("Added shop item button: " + item.name, "InventoryDisplay")
			else:
				DebugLogger.error("Failed to connect pressed signal for shop item: " + item.name, "InventoryDisplay")
	
	# Update credits display
	if currency_label:
		currency_label.text = "Credits: " + str(credits)
