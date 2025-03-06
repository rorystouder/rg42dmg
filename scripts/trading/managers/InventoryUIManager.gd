# res://scripts/trading/InventoryUIManager.gd
extends Node
class_name InventoryUIManager

var button_manager: InvButtonManager = null

func _init():
	button_manager = InvButtonManager.new()

# Populate player inventory buttons
func populate_player_inventory(player_inventory: Inventory, player_items_container: VBoxContainer, callback: Callable) -> Array[Button]:
	var buttons: Array[Button] = []
	if not player_inventory or not player_inventory.slots:
		return buttons

	for i in player_inventory.slots.size():
		var item = player_inventory.slots[i]
		var button = button_manager.create_button(item.name + " (" + item.type + ")", callback.bind(i))
		player_items_container.add_child(button)
		buttons.append(button)
		DebugLogger.log("Added player item button: " + item.name, "InventoryUIManager")
	return buttons

# Populate shop inventory buttons
func populate_shop_inventory(shop_inventory: Inventory, shop_items_container: VBoxContainer, callback: Callable) -> Array[Button]:
	var buttons: Array[Button] = []
	if not shop_inventory or not shop_inventory.slots:
		return buttons

	for i in shop_inventory.slots.size():
		var item = shop_inventory.slots[i]
		var button = button_manager.create_button(item.name + " (" + item.type + ") - " + str(item.price) + "c", callback.bind(i))
		shop_items_container.add_child(button)
		buttons.append(button)
		DebugLogger.log("Added shop item button: " + item.name, "InventoryUIManager")
	return buttons
