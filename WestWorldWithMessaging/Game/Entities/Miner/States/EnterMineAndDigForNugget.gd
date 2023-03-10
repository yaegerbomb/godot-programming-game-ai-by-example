extends State

class_name EnterMineAndDigForNugget

func enter(miner: Miner):
	if miner.get_location() != Enums.Locations.GOLDMINE:
		miner.speak("Em at the gold mine!")
		miner.change_location(Enums.Locations.GOLDMINE)

func update(miner: Miner):
	miner.add_to_gold(1)
	
	miner.increase_fatigue()
	
	miner.speak("Pickin' up a nugget")
	
	if miner.pocket_is_full():
		miner.set_destination(Enums.Locations.BANK)		
		miner.change_state(miner.state_keys.TRAVEL_TO_LOCATION)
	
	if miner.is_thirsty():
		miner.set_destination(Enums.Locations.SALOON)		
		miner.change_state(miner.state_keys.TRAVEL_TO_LOCATION)
	
func exit(miner: Miner):
	miner.speak("Ah'm leavin' the gold mine with mah pockets full o' sweet gold")
