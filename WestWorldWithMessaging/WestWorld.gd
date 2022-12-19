extends Spatial

onready var miner: Miner
onready var miners_wife: MinersWife

func _ready():
	miner = $Miner
	miner.init(Enums.People.MINER_BOB)

	miners_wife = $MinersWife
	miners_wife.init(Enums.People.ELSA)
	
	EntityManager.init()
	EntityManager.register_entity(miner)
	EntityManager.register_entity(miners_wife)

func _on_Timer_timeout():
	miner.update()
	miners_wife.update()
