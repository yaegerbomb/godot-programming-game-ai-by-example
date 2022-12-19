extends State

class_name EatStew

func enter(miner: Miner):
	miner.speak("Smells Reaaal goood Elsa!")

func update(miner: Miner):	
	miner.speak("Tastes real good too!")
	miner.get_state_machine().revert_to_previous_state()
	
func exit(miner: Miner):
	miner.speak("Thankya li'lle lady. Ah better get back to whatever ah wuz doin'")
