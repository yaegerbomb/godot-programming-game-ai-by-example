extends Node

signal print_message(message, color)

func print_message(message: String):
	emit_signal("print_message", message)
	
func print_message_with_color(message: String, color: String):
	emit_signal("print_message", message, color)
