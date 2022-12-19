extends State

class_name VisitBathroom

func enter(miners_wife: MinersWife):
	miners_wife.speak("Walkin' to the can. Need to powda mah pretty li'lle nose")

func update(miners_wife: MinersWife):
	miners_wife.speak("Ahhhhhh! Sweet relief!")
	miners_wife.get_state_machine().revert_to_previous_state()

func exit(miners_wife: MinersWife):
	miners_wife.speak("Leavin' the Jon")
