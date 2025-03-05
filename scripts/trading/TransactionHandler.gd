extends Node
class_name TransactionHandler

var buy_button = null
var sell_button = null
var trading_ui = null
var player_inventory: Inventory = null
var shop_inventory: Inventory = null
var selected_player_item = -1
var selected_shop_item = -1

func setup(buy_btn, sell_btn, ui):
	buy_button = buy_btn
	sell_button = sell_btn
	trading_ui = ui
	if buy_button:
		buy_button.connect("pressed", _on_buy_pressed)
		print("Buy Button connected")
	if sell_button:
		sell_button.connect("pressed", _on_sell_pressed)
		print("Sell Button connected")

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv

func select_player_item(index: int):
	selected_player_item = index
	print("Selected player item: ", index)

func select_shop_item(index: int):
	selected_shop_item = index
	print("Selected shop item: ", index)

func _on_buy_pressed():
	if shop_inventory and selected_shop_item >= 0 and selected_shop_item < shop_inventory.slots.size():
		var index = selected_shop_item
		var item = shop_inventory.slots[index]
		if trading_ui.credits >= item.price and player_inventory.add_item(item):
			trading_ui.credits -= item.price
			shop_inventory.remove_item(index)
			print("Bought item: ", item.name, " New credits: ", trading_ui.credits)
			selected_shop_item = -1
			trading_ui.inventory_display.update_ui()
		else:
			print("Buy failed - Credits: ", trading_ui.credits, " Price: ", item.price)
	else:
		print("Buy failed - Invalid selection: ", selected_shop_item)

func _on_sell_pressed():
	if player_inventory and selected_player_item >= 0 and selected_player_item < player_inventory.slots.size():
		var index = selected_player_item
		var item = player_inventory.slots[index]
		trading_ui.credits += item.price / 2
		player_inventory.remove_item(index)
		shop_inventory.add_item(item)
		print("Sold item: ", item.name, " New credits: ", trading_ui.credits)
		selected_player_item = -1
		trading_ui.inventory_display.update_ui()
	else:
		print("Sell failed - Invalid selection: ", selected_player_item)
