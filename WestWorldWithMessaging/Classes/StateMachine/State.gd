extends Node

class_name State

func enter(entity):
	pass

func update(entity):
	pass
	
func exit(entity):
	pass

func on_message(entity, telegram: Telegram) -> bool:
	return false
