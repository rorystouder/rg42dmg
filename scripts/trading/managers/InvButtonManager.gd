# res://scripts/trading/ButtonManager.gd
extends Node
class_name InvButtonManager

# Create a button with a label and connect it to a callback
func create_button(text: String, callback: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.connect("pressed", callback)
	return button

# Clear buttons from a container
func clear_buttons(buttons: Array[Button], container: VBoxContainer) -> void:
	for button in buttons:
		button.queue_free()
	buttons.clear()
