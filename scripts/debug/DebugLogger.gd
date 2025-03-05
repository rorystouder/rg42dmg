# res://scripts/debug/DebugLogger.gd
extends Node

var debug_enabled = true

func log(message: String, category: String = "General"):
	if debug_enabled:
		print("[%s] %s" % [category, message])

func error(message: String, category: String = "Error"):
	if debug_enabled:
		push_error("[%s] %s" % [category, message])

func warn(message: String, category: String = "Warning"):
	if debug_enabled:
		push_warning("[%s] %s" % [category, message])
