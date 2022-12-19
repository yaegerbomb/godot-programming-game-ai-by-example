extends Node

class_name StateMachine

var _owner

var _current_state: State

var _previous_state: State

var _global_state: State


func init(owner):
	_owner = owner
	_current_state = null
	_previous_state = null
	_global_state = null
	
func set_current_state(state: State):
	_current_state = state

func set_global_state(state: State):
	_global_state = state
	
func set_previous_state(state: State):
	_previous_state = state
	
func update():
	if _global_state != null:
		_global_state.update(_owner)
		
	if _current_state != null:
		_current_state.update(_owner)
	
func change_state(new_state: State):
	assert(new_state != null, "trying to change to null state")
	
	_previous_state = _current_state
	_current_state.exit(_owner)
	_current_state = new_state
	_current_state.enter(_owner)
	
func revert_to_previous_state():
	change_state(_previous_state)
	
func is_in_state(state: State):
	return _current_state == state
	
func handle_message(telegram: Telegram):
	var handled: bool
	if _current_state != null and _current_state.has_method("on_message"):
		handled = _current_state.on_message(_owner, telegram)
	
	if !handled && _global_state != null and _global_state.has_method("on_message"):
		handled = _global_state.on_message(_owner, telegram)
	
	return handled
