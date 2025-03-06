# res://scripts/trading/CurrencyUIManager.gd
extends Node
class_name CurrencyUIManager

# Update the currency label
func update_currency_label(currency_label: Label, credits: int) -> void:
	if currency_label:
		currency_label.text = "Credits: " + str(credits)
