extends Node
class_name Inventory

@export var slots: Array[ItemData] = []
@export var size: int = 10  # Max items
signal inventory_changed

func add_item(item: ItemData) -> bool:
	if slots.size() < size:
		slots.append(item)
		emit_signal("inventory_changed")
		return true
	return false

func remove_item(index: int) -> ItemData:
	if index >= 0 and index < slots.size():
		var item = slots[index]
		slots.remove_at(index)
		emit_signal("inventory_changed")
		return item
	return null

func get_item_count() -> int:
	return slots.size()
