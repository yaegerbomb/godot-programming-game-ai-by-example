extends BaseGameEntity

class_name Miner

export (Color) var speech_color

enum state_keys {
	MINER_GLOBAL_STATE,
	ENTER_MINE_AND_DIG_FOR_GOLD,
	VISIT_BANK_AND_DEPOSIT_GOLD,
	GO_HOME_AND_SLEEP_TIL_RESTED,
	QUENCH_THIRST,
	EAT_STEW,
	TRAVEL_TO_LOCATION
}

const comfort_level = 5
const max_nuggets = 3
const thirst_level = 15
const tiredness_threshold = 5

var _location: int
var _gold: int
var _banked: int
var _thirst: int
var _fatigue: int
var _destination: int

onready var _state_machine;

onready var _states = {
	state_keys.MINER_GLOBAL_STATE: $StateMachine/Global/MinerGlobalState,
	state_keys.ENTER_MINE_AND_DIG_FOR_GOLD: $StateMachine/States/EnterMineAndDigForNugget,
	state_keys.VISIT_BANK_AND_DEPOSIT_GOLD: $StateMachine/States/VisitBankAndDepositGold,
	state_keys.GO_HOME_AND_SLEEP_TIL_RESTED: $StateMachine/States/GoHomeAndSleepTilRested,
	state_keys.QUENCH_THIRST: $StateMachine/States/QuenchThirst,
	state_keys.EAT_STEW: $StateMachine/States/EatStew,
	state_keys.TRAVEL_TO_LOCATION: $StateMachine/States/TravelToLocation
}

func init(id: int):
	.init(id)
	_location = Enums.Locations.SHACK
	_gold = 0
	_banked = 0
	_thirst = 0
	_fatigue = 0
	
func _ready():
	$MinerLabel.text = name
	_state_machine = $StateMachine
	_state_machine.init(self)
	
	_state_machine.set_current_state(_states.get(state_keys.GO_HOME_AND_SLEEP_TIL_RESTED))
	_state_machine.set_global_state(_states.get(state_keys.MINER_GLOBAL_STATE))

func change_state(key):
	_state_machine.change_state(_states[key])
	
func get_state_machine():
	return _state_machine
	
func update():
	_state_machine.update()
	
func handle_message(telegram: Telegram):
	return _state_machine.handle_message(telegram)

func get_location():
	return _location
	
func get_destination():
	return _destination
	
func set_destination(destination: int):
	_destination = destination
	
func change_location(new_location):
	_location = new_location;
	
func get_gold():
	return _gold

func set_gold_carried(amount: int):
	_gold = amount

func add_to_gold(amount: int):
	_gold += amount
	
func pocket_is_full() -> bool:
	return _gold > max_nuggets
	
func get_fatigue():
	return _fatigue
	
func is_fatigued():
	return _fatigue > tiredness_threshold

func increase_fatigue():
	_fatigue += 1

func decrease_fatigue():
	_fatigue -= 1

func get_banked():
	return _banked

func is_wealthy() -> bool:
	return _banked > comfort_level

func add_to_banked(amount: int):
	_banked += amount
	
func set_banked(amount: int):
	_banked = amount

func get_thirst():
	return _thirst
	
func increase_thirst():
	_thirst+=1
	
func is_thirsty() -> bool:
	return _thirst > thirst_level
	
func buy_and_drink_a_whiskey():
	_thirst = 0
	_banked -= 2

func speak(message: String):
	print("%s: %s" % [Enums.get_name_of_people(get_id()), message])
	Events.print_message_with_color("%s: %s" % [Enums.get_name_of_people(get_id()), message], speech_color.to_html())
