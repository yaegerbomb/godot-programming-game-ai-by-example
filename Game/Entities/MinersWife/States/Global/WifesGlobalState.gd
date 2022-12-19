extends State

class_name WifesGlobalState

var rng = RandomNumberGenerator.new()

func update(miners_wife: MinersWife):
	rng.randomize()
	if rng.randf() < .1:
		miners_wife.change_state(miners_wife.state_keys.VISIT_BATHROOM)
	pass

func on_message(miners_wife: MinersWife, telegram: Telegram) -> bool:
	match telegram.message:
		Enums.MessageTypes.HiHoneyImHome:
			miners_wife.speak("Hi honey. Let me make you some of mah fine country stew")
			miners_wife.change_state(miners_wife.state_keys.COOK_STEW)
		_:
			pass
	return true
