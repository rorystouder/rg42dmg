# res://scripts/trading/InventoryDisplay.gd
extends Node
class_name InventoryDisplay

var player_item_list = null
var shop_item_list = null
var currency_label = null
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var credits: int = 0

func setup(player_list, shop_list, label):
	player_item_list = player_list
	shop_item_list = shop_list
	currency_label = label
	update_ui()

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	update_ui()

func set_player_credits(player_credits: int):
	credits = player_credits
	update_ui()

func update_ui():
	if not player_item_list or not shop_item_list or not currency_label:
		DebugLogger.error("UI elements missing", "InventoryDisplay")
		return
	for child in player_item_list.get_children():
		child.queue_free()
	for child in shop_item_list.get_children():
		child.queue_free()
	if player_inventory and player_inventory.slots and player_item_list:
		for i in range(player_inventory.slots.size()):
			var item = player_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ")"
			var handler = get_parent().get_node_or_null("TransactionHandler")
			if handler:
				button.connect("pressed", func(): handler.select_player_item(i))
			else:
				DebugLogger.error("TransactionHandler not found", "InventoryDisplay")
			player_item_list.add_child(button)
			button.owner = get_parent()
			button.visible = true
	if shop_inventory and shop_inventory.slots and shop_item_list:
		for i in range(shop_inventory.slots.size()):
			var item = shop_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ") - " + str(item.price) + "c"
			var handler = get_parent().get_node_or_null("TransactionHandler")
			if handler:
				button.connect("pressed", func(): handler.select_shop_item(i))
			else:
				DebugLogger.error("TransactionHandler not found", "InventoryDisplay")
			shop_item_list.add_child(button)
			button.owner = get_parent()
			button.visible = true
	if currency_label:
		currency_label.text = "Credits: " + str(credits)
