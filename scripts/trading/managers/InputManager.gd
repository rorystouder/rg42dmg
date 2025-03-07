# res://scripts/trading/InputManager.gd
extends Node
class_name InputManager

var trading_ui = null

# Setup the InputManager with a reference to the TradingUI
func setup(ui):
	if ui:
		trading_ui = ui
		set_process_input(true)
		DebugLogger.log("InputManager setup complete - TradingUI: " + str(trading_ui), "InputManager")
	else:
		DebugLogger.error("InputManager setup failed - TradingUI is null", "InputManager")

# Handle input events
func _input(event):
	# Check if the Escape key is pressed and the TradingUI is visible
	if event.is_action_pressed("ui_cancel"):
		DebugLogger.log("Escape key pressed", "InputManager")
		if trading_ui and trading_ui.visible:
			DebugLogger.log("Closing Trading UI", "InputManager")
			trading_ui.visible = false
			get_tree().paused = false
		else:
			DebugLogger.log("Trading UI is not visible or not set", "InputManager")
