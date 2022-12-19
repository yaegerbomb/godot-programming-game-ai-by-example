extends State

class_name GoHomeAndSleepTilRested

func enter(miner: Miner):
	if miner.get_location() != Enums.Locations.SHACK:
		miner.speak("Ah home sweet home!")
		miner.change_location(Enums.Locations.SHACK)
		MessageDispatcher.dispatch_message(0.0, miner.get_id(), Enums.People.ELSA, Enums.MessageTypes.HiHoneyImHome, null)

func update(miner: Miner):
	if !miner.is_fatigued():
		miner.speak("What a God darn fantastic nap! Time to find more gold")
		miner.set_destination(Enums.Locations.GOLDMINE)
		miner.change_state(miner.state_keys.TRAVEL_TO_LOCATION)
	else:
		miner.decrease_fatigue()
		miner.speak("ZZZZzzzzz...")

func on_message(miner: Miner, telegram: Telegram):
	match telegram.message:
		Enums.MessageTypes.StewReady:
			miner.speak("Okay hun, ahm a-comin'!")
			miner.change_state(miner.state_keys.EAT_STEW)
			return true

	return false
