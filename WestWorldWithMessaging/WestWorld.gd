extends Spatial

onready var miner: Miner
onready var miners_wife: MinersWife

func _ready():
	miner = $People/Bob
	miner.init(Enums.People.MINER_BOB)

	miners_wife = $People/Elsa
	miners_wife.init(Enums.People.ELSA)
	
	PersonManager.init()
	PersonManager.register_entity(miner)
	PersonManager.register_entity(miners_wife)
	
	var locations = $Locations.get_children()
	LocationManager.init()
	for location in locations:
		location.init(location.location_key)
		LocationManager.register_entity(location)

func _on_Timer_timeout():
	miner.update()
	miners_wife.update()
