extends State

class_name CookStew

func update(miners_wife: MinersWife):
	if !miners_wife.is_cooking():
		miners_wife.speak("Puttin' the stew in the oven")
		
		MessageDispatcher.dispatch_message(1.5, miners_wife.get_id(), miners_wife.get_id(), Enums.MessageTypes.StewReady, null)
		
		miners_wife.set_cooking(true)
	pass

func on_message(miners_wife: MinersWife, telegram: Telegram):
	match telegram.message:
		Enums.MessageTypes.StewReady:
			miners_wife.speak("Stew ready! Let's Eat")
			MessageDispatcher.dispatch_message(0.0, miners_wife.get_id(), Enums.People.MINER_BOB, Enums.MessageTypes.StewReady, null)
			miners_wife.set_cooking(false)
			miners_wife.change_state(miners_wife.state_keys.DO_HOUSE_WORK)
			return true

	return false
