extends State

class_name VisitBankAndDepositGold

func enter(miner: Miner):
	if miner.get_location() != Enums.Locations.BANK:
		miner.speak("Yes siree I'm at the bank!")
		miner.change_location(Enums.Locations.BANK)

func update(miner: Miner):
	miner.add_to_banked(miner.get_gold())
	miner.set_gold_carried(0)
	
	miner.speak("Depositing gold. Total savings now: %s" % [miner.get_banked()])
	
	if miner.is_wealthy():
		miner.speak("WooHoo! Rich enough for now. Back home to mah li'lle lady")
		miner.set_destination(Enums.Locations.SHACK)		
		miner.change_state(miner.state_keys.TRAVEL_TO_LOCATION)
	else:
		miner.set_destination(Enums.Locations.GOLDMINE)		
		miner.change_state(miner.state_keys.TRAVEL_TO_LOCATION)
	
func exit(miner: Miner):
	miner.speak("Leavin' the bank")
	pass
