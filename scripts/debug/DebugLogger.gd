# res://scripts/debug/DebugLogger.gd
extends Node

# Toggle for enabling/disabling debug output
var debug_enabled: bool = true

# Logs a standard message
func log(message: String, context: String = ""):
	if debug_enabled:
		var formatted_message = "[%s] %s" % [context, message] if context else message
		print(formatted_message)

# Logs a warning message
func warn(message: String, context: String = ""):
	if debug_enabled:
		var formatted_message = "[%s] %s" % [context, message] if context else message
		push_warning(formatted_message)

# Logs an error message
func error(message: String, context: String = ""):
	if debug_enabled:
		var formatted_message = "[%s] %s" % [context, message] if context else message
		push_error(formatted_message)
