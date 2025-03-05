# res://scripts/trading/InputManager.gd
extends Node
class_name InputManager

var trading_ui = null

func setup(ui):
	trading_ui = ui
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel") and trading_ui and trading_ui.visible:
		DebugLogger.log("Escape pressed - Closing Trading UI", "InputManager")
		trading_ui.visible = false
		get_tree().paused = false
