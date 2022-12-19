extends State

class_name DoHouseWork
var rng = RandomNumberGenerator.new()


func update(miners_wife: MinersWife):
	rng.randomize()
	var next_random = rng.randi_range(0, 3)
	match next_random:
		0:
			miners_wife.speak("Moppin' the floor")
		1:
			miners_wife.speak("Washin' the dishes")			
		2:
			miners_wife.speak("Makin' the bed")
