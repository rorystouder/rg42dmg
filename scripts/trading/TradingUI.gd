extends Control

@onready var player_item_list = $Panel/PlayerInventory/ItemList
@onready var shop_item_list = $Panel/ShopInventory/ItemList
@onready var currency_label = $Panel/CurrencyLabel
@onready var buy_button = $Panel/BuyButton
@onready var sell_button = $Panel/SellButton

var player_inventory: Inventory
var shop_inventory: Inventory
var credits: int = 1000

func _ready():
	buy_button.connect("pressed", _on_buy_pressed)
	sell_button.connect("pressed", _on_sell_pressed)
	update_ui()

func set_inventories(player_inv: Inventory, shop_inv: Inventory):
	player_inventory = player_inv
	shop_inventory = shop_inv
	player_inventory.connect("inventory_changed", update_ui)
	update_ui()

func update_ui():
	player_item_list.clear()
	shop_item_list.clear()
	for item in player_inventory.slots:
		player_item_list.add_item(item.name + " (" + item.type + ")")
	for item in shop_inventory.slots:
		shop_item_list.add_item(item.name + " (" + item.type + ") - " + str(item.price) + "c")
	currency_label.text = "Credits: " + str(credits)

func _on_buy_pressed():
	var selected = shop_item_list.get_selected_items()
	if selected.size() > 0:
		var index = selected[0]
		var item = shop_inventory.remove_item(index)
		if item and credits >= item.price and player_inventory.add_item(item):
			credits -= item.price
			update_ui()

func _on_sell_pressed():
	var selected = player_item_list.get_selected_items()
	if selected.size() > 0:
		var index = selected[0]
		var item = player_inventory.remove_item(index)
		if item:
			credits += item.price / 2  # Half price for selling
			shop_inventory.add_item(item)
			update_ui()
