extends Node

enum Locations { SHACK, GOLDMINE, BANK, SALOON }
enum People {
	MINER_BOB,
	ELSA
}
enum MessageTypes {
	HiHoneyImHome,
	StewReady
}

func get_name_of_people(person: int):
	match person:
		People.MINER_BOB:
			return "Miner Bob"
		People.ELSA:
			return "Elsa"
		_:
			return "Unknown"
			
func get_message_name(message: int):
	match message:
		MessageTypes.HiHoneyImHome:
			return "HiHonesyImHome"
		MessageTypes.StewReady:
			return "StewReady"
		_:
			return "Not Recognized"
		
