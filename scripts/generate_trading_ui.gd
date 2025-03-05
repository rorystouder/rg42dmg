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
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0

	# Panel (centered, 80% of viewport width/height)
	var panel = Panel.new()
	panel.name = "Panel"
	panel.anchor_left = 0.1  # 10% from left
	panel.anchor_right = 0.9  # 90% from left
	panel.anchor_top = 0.1   # 10% from top
	panel.anchor_bottom = 0.9 # 90% from top
	root.add_child(panel)
	panel.owner = root

	# PlayerInventory (VBoxContainer, left side)
	var player_inventory = VBoxContainer.new()
	player_inventory.name = "PlayerInventory"
	player_inventory.anchor_left = 0.0
	player_inventory.anchor_top = 0.0
	player_inventory.anchor_right = 0.45  # Half-width minus margin
	player_inventory.anchor_bottom = 0.8  # Leave room for buttons
	player_inventory.offset_left = 10
	player_inventory.offset_top = 10
	player_inventory.offset_right = -10
	player_inventory.offset_bottom = -50
	panel.add_child(player_inventory)
	player_inventory.owner = root

	var player_label = Label.new()
	player_label.name = "Label"
	player_label.text = "Player Inventory"
	player_inventory.add_child(player_label)
	player_label.owner = root

	var player_item_list = ItemList.new()
	player_item_list.name = "ItemList"
	player_inventory.add_child(player_item_list)
	player_item_list.owner = root

	# ShopInventory (VBoxContainer, right side)
	var shop_inventory = VBoxContainer.new()
	shop_inventory.name = "ShopInventory"
	shop_inventory.anchor_left = 0.55  # Start after PlayerInventory
	shop_inventory.anchor_top = 0.0
	shop_inventory.anchor_right = 1.0
	shop_inventory.anchor_bottom = 0.8
	shop_inventory.offset_left = 10
	shop_inventory.offset_top = 10
	shop_inventory.offset_right = -10
	shop_inventory.offset_bottom = -50
	panel.add_child(shop_inventory)
	shop_inventory.owner = root

	var shop_label = Label.new()
	shop_label.name = "Label"
	shop_label.text = "Shop"
	shop_inventory.add_child(shop_label)
	shop_label.owner = root

	var shop_item_list = ItemList.new()
	shop_item_list.name = "ItemList"
	shop_inventory.add_child(shop_item_list)
	shop_item_list.owner = root

	# CurrencyLabel (bottom center)
	var currency_label = Label.new()
	currency_label.name = "CurrencyLabel"
	currency_label.text = "Credits: 1000"
	currency_label.anchor_left = 0.4
	currency_label.anchor_right = 0.6
	currency_label.anchor_bottom = 1.0
	currency_label.offset_bottom = -10
	currency_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(currency_label)
	currency_label.owner = root

	# BuyButton (bottom right)
	var buy_button = Button.new()
	buy_button.name = "BuyButton"
	buy_button.text = "Buy"
	buy_button.anchor_right = 1.0
	buy_button.anchor_bottom = 1.0
	buy_button.offset_right = -10
	buy_button.offset_bottom = -10
	buy_button.size = Vector2(100, 40)
	panel.add_child(buy_button)
	buy_button.owner = root

	# SellButton (bottom left)
	var sell_button = Button.new()
	sell_button.name = "SellButton"
	sell_button.text = "Sell"
	sell_button.anchor_left = 0.0
	sell_button.anchor_bottom = 1.0
	sell_button.offset_left = 10
	sell_button.offset_bottom = -10
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
