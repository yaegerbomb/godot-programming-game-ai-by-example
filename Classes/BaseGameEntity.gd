extends Node

class_name BaseGameEntity

var _id: int setget set_id, get_id


func set_id(val: int):
	_id = val
	
func get_id():
	return _id

func init(id: int):
	set_id(id)

func update():
	pass

func handle_message(message: Telegram):
	pass
