extends Control

class_name UIControl

export (NodePath) var tick_node_path
onready var tick_timer: Timer = get_node(tick_node_path)

signal console_paused(paused)


func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		if tick_timer.is_paused():
			tick_timer.set_paused(false)
			emit_signal("console_paused", false)
		else:
			tick_timer.set_paused(true)
			emit_signal("console_paused", true)
