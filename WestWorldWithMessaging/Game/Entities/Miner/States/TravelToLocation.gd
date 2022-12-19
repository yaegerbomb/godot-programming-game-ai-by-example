extends State

class_name TravelToLocation

var tween: SceneTreeTween 

func enter(miner: Miner):
	if miner.get_location() != miner.get_destination():
		var location: Location = LocationManager.get_entity_from_id(miner.get_destination())
		miner.speak("Time to walk to %s!" % [Enums.get_location_name(miner.get_destination())])
		tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.connect("finished", self, "arrived_at_destination", [miner])
		var location_to_tween = Vector3(location.global_transform.origin.x, location.global_transform.origin.y, miner.transform.origin.z)
		tween.tween_property(miner, "global_translation", location_to_tween, 5.0)

func update(miner: Miner):
	miner.speak("Just keep walkin'!")

func arrived_at_destination(miner: Miner):
	match miner.get_destination():
		Enums.Locations.BANK:
			miner.change_state(miner.state_keys.VISIT_BANK_AND_DEPOSIT_GOLD)
		Enums.Locations.GOLDMINE:
			miner.change_state(miner.state_keys.ENTER_MINE_AND_DIG_FOR_GOLD)
		Enums.Locations.SALOON:
			miner.change_state(miner.state_keys.QUENCH_THIRST)
		Enums.Locations.SHACK:
			miner.change_state(miner.state_keys.GO_HOME_AND_SLEEP_TIL_RESTED)
	
func exit(miner: Miner):
	miner.speak("Ah'm at my desination!")
	
