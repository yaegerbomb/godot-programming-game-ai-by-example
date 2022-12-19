extends State

class_name VisitBankAndDepositGold

func enter(miner: Miner):
	if miner.get_location() != Enums.Locations.BANK:
		miner.speak("Goin' to the bank. Yes siree")
		miner.change_location(Enums.Locations.BANK)

func update(miner: Miner):
	miner.add_to_banked(miner.get_gold())
	miner.set_gold_carried(0)
	
	miner.speak("Depositing gold. Total savings now: %s" % [miner.get_banked()])
	
	if miner.is_wealthy():
		miner.speak("WooHoo! Rich enough for now. Back home to mah li'lle lady")
		miner.change_state(miner.state_keys.GO_HOME_AND_SLEEP_TIL_RESTED)
	else:
		miner.change_state(miner.state_keys.ENTER_MINE_AND_DIG_FOR_GOLD)
	
func exit(miner: Miner):
	miner.speak("Leavin' the bank")
	pass
