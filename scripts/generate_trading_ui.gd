@tool
extends EditorScript

func _run():
	print("Generating TradingUI.tscn...")
	var dir = DirAccess.open("res://scenes/")
	if not dir.dir_exists("res://scenes/"):
		dir.make_dir("res://scenes/")

	# Create the scene
	var root = Control.new()
	root.name = "TradingUI"
	root.anchor_right = 1.0  # Full width
	root.anchor_bottom = 1.0  # Full height

	# Panel
	var panel = Panel.new()
	panel.name = "Panel"
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.size = Vector2(600, 400)  # Default size
	panel.position = Vector2(200, 100)  # Center-ish
	root.add_child(panel)
	panel.owner = root

	# PlayerInventory (VBoxContainer)
	var player_inventory = VBoxContainer.new()
	player_inventory.name = "PlayerInventory"
	player_inventory.anchor_left = 0.0
	player_inventory.anchor_top = 0.0
	player_inventory.position = Vector2(20, 20)  # Top-left
	panel.add_child(player_inventory)
	player_inventory.owner = root

	var player_label = Label.new()
	player_label.name = "Label"
	player_label.text = "Player Inventory"
	player_inventory.add_child(player_label)
	player_label.owner = root

	var player_item_list = ItemList.new()
	player_item_list.name = "ItemList"
	player_item_list.size = Vector2(250, 300)  # Fixed size
	player_inventory.add_child(player_item_list)
	player_item_list.owner = root

	# ShopInventory (VBoxContainer)
	var shop_inventory = VBoxContainer.new()
	shop_inventory.name = "ShopInventory"
	shop_inventory.anchor_right = 1.0
	shop_inventory.anchor_top = 0.0
	shop_inventory.position = Vector2(330, 20)  # Top-right offset
	panel.add_child(shop_inventory)
	shop_inventory.owner = root

	var shop_label = Label.new()
	shop_label.name = "Label"
	shop_label.text = "Shop"
	shop_inventory.add_child(shop_label)
	shop_label.owner = root

	var shop_item_list = ItemList.new()
	shop_item_list.name = "ItemList"
	shop_item_list.size = Vector2(250, 300)  # Fixed size
	shop_inventory.add_child(shop_item_list)
	shop_item_list.owner = root

	# CurrencyLabel
	var currency_label = Label.new()
	currency_label.name = "CurrencyLabel"
	currency_label.text = "Credits: 1000"
	currency_label.anchor_bottom = 1.0
	currency_label.anchor_left = 0.5
	currency_label.position = Vector2(300, 350)  # Bottom-center
	panel.add_child(currency_label)
	currency_label.owner = root

	# BuyButton
	var buy_button = Button.new()
	buy_button.name = "BuyButton"
	buy_button.text = "Buy"
	buy_button.anchor_right = 1.0
	buy_button.anchor_bottom = 1.0
	buy_button.position = Vector2(450, 320)  # Bottom-right
	buy_button.size = Vector2(100, 40)
	panel.add_child(buy_button)
	buy_button.owner = root

	# SellButton
	var sell_button = Button.new()
	sell_button.name = "SellButton"
	sell_button.text = "Sell"
	sell_button.anchor_bottom = 1.0
	sell_button.position = Vector2(50, 320)  # Bottom-left
	sell_button.size = Vector2(100, 40)
	panel.add_child(sell_button)
	sell_button.owner = root

	# Attach TradingUI.gd script
	root.set_script(load("res://scripts/TradingUI.gd"))

	# Save the scene
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://scenes/TradingUI.tscn")
	print("TradingUI.tscn generated successfully!")
