extends Node

const send_message_immediately: float = 0.0
	
func discharge(receiver: BaseGameEntity, telegram: Telegram):
	if !receiver.has_method("handle_message"):
		printerr("Error")
		
	receiver.handle_message(telegram)

func dispatch_message(delay: float, sender: int, receiver: int, message: int, additional_info):
	var receiving_entity: BaseGameEntity = EntityManager.get_entity_from_id(receiver);
	
	if receiving_entity == null:
		printerr("Warning: No receiver with ID of %s found", [receiver])
	
	var telegram = Telegram.new()
	telegram.init_v(sender, receiver, message, delay, additional_info)
	
	if delay <= send_message_immediately:
		discharge(receiving_entity, telegram)
	else:
		yield(get_tree().create_timer(delay), "timeout")
		discharge(receiving_entity, telegram)
