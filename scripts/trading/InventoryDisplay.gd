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
	print("Set inventories - Player: ", player_inventory, " Shop: ", shop_inventory)
	if player_inventory:
		print("Player inventory slots: ", player_inventory.slots)
		player_inventory.connect("inventory_changed", update_ui)
	if shop_inventory:
		print("Shop inventory slots: ", shop_inventory.slots)
	update_ui()

func set_player_credits(player_credits: int):
	credits = player_credits
	print("Credits set to: ", credits)
	update_ui()

func update_ui():
	print("Updating UI - Player Item List: ", player_item_list)
	if player_item_list:
		for child in player_item_list.get_children():
			child.queue_free()
		print("Player Item List cleared")
	else:
		print("Error: player_item_list is null")
	print("Updating UI - Shop Item List: ", shop_item_list)
	if shop_item_list:
		for child in shop_item_list.get_children():
			child.queue_free()
		print("Shop Item List cleared")
	else:
		print("Error: shop_item_list is null")
	print("Updating UI - Player slots: ", player_inventory.slots if player_inventory else "null")
	if player_inventory and player_inventory.slots and player_item_list:
		for i in range(player_inventory.slots.size()):
			var item = player_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ")"
			button.connect("pressed", func(): get_parent().get_node("TransactionHandler").select_player_item(i))
			player_item_list.add_child(button)
			button.owner = get_parent()
			print("Added player item button: ", item.name)
	print("Updating UI - Shop slots: ", shop_inventory.slots if shop_inventory else "null")
	if shop_inventory and shop_inventory.slots and shop_item_list:
		for i in range(shop_inventory.slots.size()):
			var item = shop_inventory.slots[i]
			var button = Button.new()
			button.text = item.name + " (" + item.type + ") - " + str(item.price) + "c"
			button.connect("pressed", func(): get_parent().get_node("TransactionHandler").select_shop_item(i))
			shop_item_list.add_child(button)
			button.owner = get_parent()
			print("Added shop item button: ", item.name)
	print("Updating UI - Currency Label: ", currency_label)
	if currency_label:
		currency_label.text = "Credits: " + str(credits)
	else:
		print("Error: currency_label is null")
