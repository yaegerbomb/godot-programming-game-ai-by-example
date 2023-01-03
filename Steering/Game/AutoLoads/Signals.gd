extends Node

signal on_movement_paused_toggled
signal on_pursue_toggled

signal on_left_click(point)
signal on_left_click_released(point)
signal on_right_click(point)
signal on_right_click_released(point)
signal on_mouse_move(point)
	
func emit_on_movement_paused_toggled():
	emit_signal("on_movement_paused_toggled")
	
func emit_on_pursue_toggled():
	emit_signal("on_pursue_toggled")

func on_mouse_move(point: Vector3):
	emit_signal("on_mouse_move", point)
	
func emit_on_left_click(point: Vector3):
	emit_signal("on_left_click", point)

func emit_on_left_click_released(point: Vector3):
	emit_signal("on_left_click_released", point)

func emit_on_right_click(point: Vector3):
	emit_signal("on_right_click", point)
	
func emit_on_right_click_released(point: Vector3):
	emit_signal("on_right_click_released", point)
