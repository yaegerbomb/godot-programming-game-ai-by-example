extends BaseGameEntity

class_name MinersWife

export (Color) var speech_color

enum state_keys {
	MINERS_WIFE_GLOBAL_STATE,
	DO_HOUSE_WORK,
	VISIT_BATHROOM,
	COOK_STEW
}

var _location: int
var _cooking: bool

onready var _state_machine;

onready var _states = {
	state_keys.MINERS_WIFE_GLOBAL_STATE: $StateMachine/Global/WifesGlobalState,
	state_keys.DO_HOUSE_WORK: $StateMachine/States/DoHouseWork,
	state_keys.VISIT_BATHROOM: $StateMachine/States/VisitBathroom,
	state_keys.COOK_STEW: $StateMachine/States/CookStew
}

func init(id: int):
	.init(id)
	_location = Enums.Locations.SHACK
	_cooking = false
	
func _ready():
	$MinersWifeLabel.text = name
	_state_machine = $StateMachine
	_state_machine.init(self)
	
	_state_machine.set_current_state(_states.get(state_keys.DO_HOUSE_WORK))
	_state_machine.set_global_state(_states.get(state_keys.MINERS_WIFE_GLOBAL_STATE))
	
func change_state(key):
	_state_machine.change_state(_states[key])

func update():
	_state_machine.update()
	
func handle_message(telegram: Telegram):
	return _state_machine.handle_message(telegram)

func get_state_machine():
	return _state_machine

func get_location():
	return _location

func change_location(new_location):
	_location = new_location;
	
func is_cooking():
	return _cooking
	
func set_cooking(cooking: bool):
	_cooking = cooking

func speak(message: String):
	print("%s: %s" % [Enums.get_name_of_people(get_id()), message])
	Events.print_message_with_color("%s: %s" % [Enums.get_name_of_people(get_id()), message], speech_color.to_html())
