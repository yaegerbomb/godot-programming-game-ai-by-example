extends State

class_name QuenchThirst

func enter(miner: Miner):
	if miner.get_location() != Enums.Locations.SALOON:
		miner.speak("Boy, ah sure is thusty! Walking to the saloon")
		miner.change_location(Enums.Locations.SALOON)

func update(miner: Miner):
	if miner.is_thirsty():
		miner.buy_and_drink_a_whiskey()
		miner.speak("That's mighty fine sippin liquer")
		miner.change_state(miner.state_keys.ENTER_MINE_AND_DIG_FOR_GOLD)
	else:
		printerr("ERROR! ERROR! ERROR!")

	
func exit(miner: Miner):
		miner.speak("Leaving the saloon, feelin' good")
